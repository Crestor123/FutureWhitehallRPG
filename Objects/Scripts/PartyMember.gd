extends Node

class_name PartyMember

@export var data : Resource

@onready var Abilities = $AbilityComponent
@onready var Stats = $StatComponent
@onready var Equipment = $EquipmentComponent

var level : int = 0
var experience : int = 0
var xpToLevel : int = 0

var partyName : String
var sprite : Texture2D
var isActive : bool = false
var alive : bool = true

signal updateHealthBar(value)
signal dead(data)

func initialize():
	if !data: return
	partyName = data.name
	sprite = data.sprite
	level = data.level
	for item in data.stats:
		Stats.stats[item] = data.stats[item]
	Stats.tempStats["health"] = Stats.stats["health"]
	Stats.tempStats["mana"] = Stats.stats["mana"]
	for item in data.resistances:
		Stats.resistances[item] = data.resistances[item]
	for item in data.abilities:
		Abilities.add_ability(item)
	
func xp_to_next_level():
	pass
	
func add_xp():
	pass
	
func level_up():
	pass
	
func equip():
	pass
	
func start_turn():
	pass
	
func die():
	pass
