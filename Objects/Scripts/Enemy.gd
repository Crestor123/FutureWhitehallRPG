extends Node2D

@onready var Sprite = $Sprite2D
@onready var Abilities = $AbilityComponent
@onready var Stats = $StatComponent
@onready var Select = $Sprite2D/Button

@export var data : EnemyResource

signal on_select

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

func _on_button_pressed():
	on_select.emit(self)
