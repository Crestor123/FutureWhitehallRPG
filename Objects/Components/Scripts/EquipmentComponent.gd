extends Node

#@export var Inventory : Node = null
@export var Target : Node = null

#Slots point to equipmentNodes that are children of this node
var equipmentSlots = {
	"mainhand": {"type": "weapon", "equip": null},
	"offhand": {"type": "weapon", "equip": null},
	"head": {"type": "head", "equip": null},
	"body": {"type": "body", "equip": null},
	"accessory": {"type": "accessory", "equip": null}
}

var equipStats = {
	"health": 0,
	"mana": 0,
	"strength": 0,	#Affects physical melee damage
	"intelligence": 0,	#Affects magic damage
	"dexterity": 0,	#Affects ranged damage
	"speed": 0,
	"vitality": 0,
	"resistance": 0,
}

var equipResistances = {
	"fire": 0,
	"electricity": 0,
	"water": 0,
	"acid": 0,
	"air": 0,
	"void": 0,
	"earth": 0
}

var equipStatusResist = {
	"burn": 0,
	"sleep": 0,
	"silence": 0,
	"slow": 0,
	"stun": 0,
	"blind": 0
}

func equip(equipment: EquipNode, slot : String) -> bool:
	if !slot in equipmentSlots: return false
	
	var equipped = false
	
	#The item is equipped by another party member
	if equipment.Owner != null and equipment.Owner != Target:
		return false
	
	#The item is equipped in a different slot
	if equipment.Owner == Target:
		for i in equipmentSlots:
			if equipmentSlots[i]["equip"] == equipment:
				equipmentSlots[i]["equip"] = null
	
	#There is already an item in the selected slot
	if equipmentSlots[slot]["equip"] != null:
		unequip(equipmentSlots[slot]["equip"])
		#equipmentSlots[slot]["equip"].Owner = null
		#equipmentSlots[slot]["equip"] = null
	
	#Equip the item
	equipmentSlots[slot]["equip"] = equipment
	equipment.Owner = Target
	
	#If the item is a firearm, add charge to it and the proper abilities
	if equipment is FirearmNode:
		reload(equipment)
			
		#if Target.Inventory.CurrentCharge >= equipment.totalCharge:
			#Target.Inventory.CurrentCharge -= equipment.totalCharge
			#equipment.currentCharge = equipment.totalCharge
		#else:
			#var charge = Target.Inventory.CurrentCharge
			#Target.Inventory.CurrentCharge = 0
			#equipment.currentCharge = charge
	
	#If the item has abilities, add those to the party member
	if equipment.abilities.size() > 0:
		for i in equipment.abilities:
			Target.Abilities.add_ability(i, equipment)
	
	equipped = true
	
	update_stats()
	
	return equipped
	pass

func unequip(equipment : EquipNode) -> bool:
	var unequipped = false
	for item in equipmentSlots:
		if equipmentSlots[item]["equip"] == equipment:
			equipmentSlots[item]["equip"].Owner = null
			equipmentSlots[item]["equip"] = null
			
			if equipment is FirearmNode:
				Target.Inventory.CurrentCharge += equipment.currentCharge
				equipment.currentCharge = 0
				
			#If the item has abilities, remove those from the party member
			if equipment.abilities.size() > 0:
				for i in equipment.abilities:
					Target.Abilities.remove_ability(i, equipment)
			unequipped = true
			break
			
	update_stats()
	return unequipped
	pass

func update_stats():
	for item in equipStats:
		equipStats[item] = 0
	for item in equipResistances:
		equipResistances[item] = 0
	for item in equipStatusResist:
		equipStatusResist[item] = 0
	
	for item in equipmentSlots:
		if equipmentSlots[item]["equip"] != null:
			var equipment = equipmentSlots[item]["equip"]
			for stat in equipStats:
				equipStats[stat] += equipment.bonuses[stat]
			for stat in equipResistances:
				equipResistances[stat] += equipment.resistances[stat]
			for stat in equipStatusResist:
				equipStatusResist[stat] += equipment.statusResists[stat]

func reload(equipment : EquipNode):
	while equipment.currentCharge < equipment.totalCharge and Target.Inventory.CurrentCharge > equipment.chargePerShot:
			equipment.currentCharge += equipment.chargePerShot
			Target.Inventory.CurrentCharge -= equipment.chargePerShot
	pass

func spend_charge(amount : int):
	for item in equipmentSlots:
		if equipmentSlots[item]["equip"] is FirearmNode:
			equipmentSlots[item]["equip"].currentCharge -= amount
	pass

func get_charge_cost() -> int:
	var chargeCost = 0
	for item in equipmentSlots:
		if equipmentSlots[item]["equip"] is FirearmNode:
			chargeCost += equipmentSlots[item]["equip"].chargePerShot
	return chargeCost
