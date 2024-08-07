extends Node2D

@onready var Sprite = $Sprite2D
@onready var Abilities = $AbilityComponent
@onready var Stats = $StatComponent

@export var data : EnemyResource

func initialize():
	if !data: return
	
	name = data.name
	for item in data.stats:
		Stats.stats[item] = data.stats[item]
	for item in data.resistances:
		Stats.resistances[item] = data.resistances[item]
	Abilities.initialize(data.abilities)
	Sprite.texture = data.sprite
	pass

func start_turn():
	pass
