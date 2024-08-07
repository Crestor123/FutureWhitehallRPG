extends Control

@onready var label = $Label
@onready var button = $Button

var data : Node = null

signal pressed()

func initialize(ability : Node):
	data = ability
	label.text = ability.abilityName
	pass

func _on_button_pressed():
	pressed.emit(data)
