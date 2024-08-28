extends Node

@export var buffObject : PackedScene

@export var parent : Node
@export var equipment : Node

signal healthChanged
signal healthZero

var level = 1

var stats = {
	"health": 0,
	"mana": 0,
	"strength": 0,	#Affects physical melee damage
	"intelligence": 0,	#Affects magic damage
	"dexterity": 0,	#Affects ranged damage
	"speed": 0,
	"vitality": 0,
	"resistance": 0,
}

var resistances = {
	"fire": 0,
	"electricity": 0,
	"water": 0,
	"acid": 0,
	"air": 0,
	"void": 0,
	"earth": 0
}

#Holds temporary values applied to stats
#as well as current health and mana
var tempStats = {
	"health": 0,
	"mana": 0,
	"strength": 0,
	"intelligence": 0,
	"dexterity": 0,
	"speed": 0,
	"vitality": 0,
	"resistance": 0,
}

var tempResistances = {
	"fire": 0,
	"electricity": 0,
	"water": 0,
	"acid": 0,
	"air": 0,
	"void": 0,
	"earth": 0
}

func initialize():
	pass
	
func take_damage(damage : int, type : String, element : String):
	print(parent.name, " ", damage, " ", type, " ", element, " damage")
	healthChanged.emit()
	pass
	
func add_buff():
	pass
	
func tick_buffs():
	pass

func get_health(percent : bool = false):
	if percent:
		return 100 * (float(tempStats["health"]) / float(get_health()))
	else:
		return tempStats["health"]

func get_mana(percent : bool = false):
	if percent:
		return 100 * (float(tempStats["mana"]) / float(get_mana()))
	else:
		return tempStats["mana"]
	pass
	
func get_stat(stat : String):
	var result : int = 0
	
	if stat in stats:
		result += tempStats[stat] + stats[stat]
	
	if equipment:
		if stat in equipment.equipStats:
			result += equipment.equipStats[stat]
			
	return result
	
func get_resistance():
	pass
