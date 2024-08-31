extends Node

@export var buffObject : PackedScene

@export var parent : Node
@export var equipment : Node

signal healthChanged(amount)
signal healthZero

var level = 1

var stats = {
	"health": 0,
	"mana": 0,
	"strength": 0,	#Affects physical melee damage
	"intelligence": 0,	#Affects magic damage
	"dexterity": 0,	#Affects ranged damage
	"speed": 0,
	"vitality": 0,	#Affects incoming non-elemental damage
	"resistance": 0,	#Affects incoming elemental damage
}

#Percentage values that reduce incoming damage
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
	
func take_damage(value : int, type : String, element : String):
	
	var damage : int = value
	
	#Apply resistances
	if element in resistances:
		damage -= damage * get_resistance(element)
		damage -= get_stat("resistance") / 2
	else:	#The damage has no element
		damage -= get_stat("vitality")
	
	#Subtract the damage done from temphealth
	print(parent.name, " ", damage, " ", type, " ", element, " damage")
	tempStats.health -= damage
	
	if tempStats.health < 0:
		tempStats.health = 0
	
	healthChanged.emit(tempStats.health)
	if tempStats.health == 0:
		healthZero.emit()
	
func add_buff():
	pass
	
func tick_buffs():
	pass

#Returns current health value
func get_health(percent : bool = false):
	if percent:
		return 100 * (float(tempStats["health"]) / float(get_stat("health")))
	else:
		return tempStats["health"]

#Returns current mana value
func get_mana(percent : bool = false):
	if percent:
		return 100 * (float(tempStats["mana"]) / float(get_stat("mana")))
	else:
		return tempStats["mana"]
	pass
	
func get_stat(stat : String):
	var result : int = 0
	if stat == "health" or stat == "mana":
		result += stats[stat]
	elif stat in stats:
		result += tempStats[stat] + stats[stat]
	
	if equipment:
		if stat in equipment.equipStats:
			result += equipment.equipStats[stat]
			
	return result
	
func get_resistance(res : String):
	var result : int = 0
	
	if res in resistances:
		result += tempResistances[res] + resistances[res]
		
	if equipment:
		if res in equipment.equipResistances:
			result += equipment.equipResistances[res]
	
	return result
