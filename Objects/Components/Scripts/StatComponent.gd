extends Node

@export var buffObject : PackedScene

@export var parent : Node
@export var equipment : Node
@export var caster : Node
@export var battler : Node

signal reviveSignal
signal takeDamage(amount)
signal healthChanged(amount)
signal healthZero

var level = 1
var dead = false

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

var statusResist = {
	"burn": 0,
	"sleep": 0,
	"silence": 0,
	"slow": 0,
	"stun": 0,
	"blind": 0
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

var tempStatusResist = {
	"burn": 0,
	"sleep": 0,
	"silence": 0,
	"slow": 0,
	"stun": 0,
	"blind": 0
}

func initialize():
	pass
	
func revive():
	reviveSignal.emit()

func spend_mana(value : int):
	tempStats.mana -= value

func heal(value : int):
	print(parent.Name, " heals ", value)
	tempStats.health += value
	if tempStats.health > get_stat("health"):
		tempStats.health = get_stat("health")
	healthChanged.emit(tempStats.health)

func take_damage(value : int, type : String, element : String):
	
	var damage : int = value
	if damage < 0:
		heal(-damage)
		return
	
	#Apply resistances
	if element in resistances:
		damage -= damage * float(get_resistance(element)) / 100
		damage -= get_stat("resistance") / 2
	elif type != "none":	#The damage has no element
		damage -= get_stat("vitality")
	
	#Error Checking
	if value >= 0:
		if damage < 0: damage = 0	#Damage cannot be reduced below 0
	
	#Subtract the damage done from temphealth
	print(parent.name, " ", damage, " ", type, " ", element, " damage")
	tempStats.health -= damage
	
	if tempStats.health < 0:
		tempStats.health = 0
	if tempStats.health > get_stat("health"):
		tempStats.health = get_stat("health")
	
	takeDamage.emit(damage)
	healthChanged.emit(tempStats.health)
	if tempStats.health < 1:
		healthZero.emit()
	
func add_buff(source, ability, effect):
	#Check status resistances
	if effect.status in statusResist:
		var rand = randi_range(1, 100)
		if rand < get_resistance(effect.status): 
			#The status failed
			print("Status failed to apply")
			return
	
	for item in get_children():
		if item.source == source and item.ability == ability:
			#There is already a buff from the same source active
			item.turns = ability.turns	#Reset the buff's turn counter
			return
	var newBuff = buffObject.instantiate()
	add_child(newBuff)
	newBuff.initialize(source, ability, effect)
	pass
	
func tick_buffs():
	for buff in get_children():
		buff.tick()
	pass

#Returns current health value
func get_health(percent : bool = false):
	if percent:
		return 100 * (floor(float(tempStats["health"])) / floor(float(get_stat("health"))))
	else:
		return tempStats["health"]

#Returns current mana value
func get_mana(percent : bool = false):
	if percent:
		return 100 * (floor(float(tempStats["mana"])) / floor(float(get_stat("mana"))))
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
	if caster:
		if stat in caster.stats:
			result += caster.stats[stat]
			
	return floor(result)
	
func get_resistance(res : String):
	var result : int = 0
	
	if res in resistances:
		result += tempResistances[res] + resistances[res]
	if res in statusResist:
		result += tempStatusResist[res] + statusResist[res]
		
	if equipment:
		if res in equipment.equipResistances:
			result += equipment.equipResistances[res]
		if res in equipment.equipStatusResist:
			result += equipment.equipStatusResist[res]
	if caster:
		if res in caster.resistances:
			result += caster.resistances[res]
		if res in caster.statusResist:
			result += caster.statusResist[res]
	
	return floor(result)
