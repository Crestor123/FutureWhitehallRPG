extends Node

@export var inventory : Node = null

#Slots point to equipmentNodes that are children of this node
var equipmentSlots = {
	"weapon": null,
	"sidearm": null,
	"head": null,
	"body": null,
	"accesory": null
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

func equip(equipment: EquipNode, slot : String = "") -> bool:
	if inventory == null: return false
	if !slot in equipmentSlots: return false
	
	var equipped = false
	
	inventory.transferItem(equipment, self)
	if equipmentSlots[slot] != null:
		equipmentSlots[slot].reparent(inventory)
		equipmentSlots[slot] = null
	if equipmentSlots[slot] == null:
		equipmentSlots[slot] = equipment
		equipped = true
	
	update_stats()
	
	return equipped
	pass

func unequip(equipment : EquipNode) -> bool:
	if inventory == null: return false
	var unequipped = false
	for item in equipmentSlots:
		if equipmentSlots[item] == equipment:
			equipment.reparent(inventory)
			equipmentSlots[item] = null
			unequipped = true
	return unequipped
	pass

func update_stats():
	for item in equipStats:
		equipStats[item] = 0
	for item in equipResistances:
		equipResistances[item] = 0
	for item in equipStatusResist:
		equipStatusResist[item] = 0
		
	for item in get_children():
		for stat in equipStats:
			equipStats[stat] += item.bonuses[stat]
		for stat in equipResistances:
			equipResistances[stat] += item.resistances[stat]
		for stat in equipStatusResist:
			equipStatusResist[stat] += item.statusResists[stat]
	pass
