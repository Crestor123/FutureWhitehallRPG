extends Node

class_name PartyMember

@export var data : PartyMemberResource

@onready var Abilities = $AbilityComponent
@onready var Stats = $StatComponent
@onready var Equipment = $EquipmentComponent
@onready var Caster = $CasterComponent

@export var baseXP : int = 10
@export var exponent : float = 1.5

var Inventory : Node = null

var level : int = 0
var experience : int = 0
var xpToLevel : int = 0

var Name : String
var sprite : Texture2D
var isActive : bool = false
var alive : bool = true

signal updateHealthBar(value)
signal dead(data)

func initialize(inventory : Node):
	if !data: return
	Inventory = inventory
	Name = data.name
	sprite = data.sprite
	level = data.level
	xpToLevel = xp_to_next_level(level)
	
	for item in data.stats:
		Stats.stats[item] = data.stats[item]
	Stats.tempStats["health"] = Stats.stats["health"]
	Stats.tempStats["mana"] = Stats.stats["mana"]
	
	for item in data.resistances:
		Stats.resistances[item] = data.resistances[item]
		
	for item in data.abilities:
		Abilities.add_ability(item)
		
	#Equipment.Inventory = Inventory
	
func xp_to_next_level(level : int):
	return floor(baseXP * (pow(level, exponent)))
	pass
	
func add_xp(amount : int):
	experience += amount
	if experience > xpToLevel:
		level_up()
	pass

func add_battle_xp(expArray : Array):
	#Takes an array of arrays: [level, exp]
	#Scale xp based on difference between player level and enemy level
	for i in expArray:
		var gainedXP = i[1]
		add_xp(gainedXP)
	pass

func level_up():
	level += 1
	xpToLevel = xp_to_next_level(level)
	
	for i in data.statGrowths:
		Stats.stats[i] += data.statGrowths[i]
	Stats.tempStats["health"] = Stats.stats["health"]
	Stats.tempStats["mana"] = Stats.stats["mana"]
	pass
