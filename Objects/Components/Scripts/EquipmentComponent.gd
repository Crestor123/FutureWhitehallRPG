extends Node

@export var inventory : Node = null

#Slots point to equipmentNodes that are children of this node
var equipment = {
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

func equip():
	pass

func unequip():
	pass

func update_stats():
	pass
