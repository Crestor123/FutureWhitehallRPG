extends Control

@onready var lblName = $HBoxContainer/Name
@onready var lblCost = $HBoxContainer/Cost
@onready var button = $Button

const MANA_COLOR = 0x6f8be6ff
const AMMO_COLOR = 0xee9489ff

var data 

signal pressed()

func set_label(labelText : String):
	lblName.text = labelText
	pass

func initialize(setData : Node):
	data = setData
	if data is ItemNode:
		lblName.text = data.itemName
	else:
		lblName.text = data.abilityName
		if data.manaCost > 0:
			lblCost.set("theme_override_colors/font_color", Color.hex(MANA_COLOR))
			lblCost.text = "(" + str(data.manaCost) + ")"
			lblCost.visible = true
		if data.realAmmoCost > 0:
			set_ammo(data.realAmmoCost)
	pass

func set_ammo(amount):
	lblCost.set("theme_override_colors/font_color", Color.hex(AMMO_COLOR))
	lblCost.text = "(" + str(amount) + ")"
	lblCost.visible = true

func disable_button():
	button.mouse_filter = MOUSE_FILTER_IGNORE
	
func enable_button():
	button.mouse_filter = MOUSE_FILTER_STOP

func _on_button_pressed():
	pressed.emit(data)
