extends Control

@onready var label = $Label
@onready var button = $Button

var data 

signal pressed()

func set_label(labelText : String):
	label.text = labelText
	pass

func initialize(setData : Node):
	data = setData
	if data is ItemNode:
		label.text = data.itemName
	else:
		label.text = data.abilityName
	pass

func _on_button_pressed():
	pressed.emit(data)
