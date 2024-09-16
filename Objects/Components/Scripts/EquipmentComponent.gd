extends Node

#@export var Inventory : Node = null

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
	
	if equipment.Owner != null and equipment.Owner != get_parent():
		return false
	
	if equipment.Owner == get_parent():
		for i in equipmentSlots:
			if equipmentSlots[i]["equip"] == equipment:
				equipmentSlots[i]["equip"] = null
	
	#Inventory.transfer_item(equipment, self)
	if equipmentSlots[slot]["equip"] != null:
		equipmentSlots[slot]["equip"].Owner = null
		equipmentSlots[slot]["equip"] = null
	
	equipmentSlots[slot]["equip"] = equipment
	equipment.Owner = get_parent()
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
			unequipped = true
			break
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
	pass
