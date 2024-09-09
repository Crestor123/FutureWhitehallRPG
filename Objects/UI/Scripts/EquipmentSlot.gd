extends Control

@onready var Icon = $HBoxContainer/Icon
@onready var lblName = $HBoxContainer/Name
@onready var btnSelect = $Select

var slot : String = ""

signal select

func initialize(setSlot, equipment : EquipNode = null):
	lblName.text = setSlot.capitalize()
	if equipment:
		Icon.texture = equipment.icon
		lblName.text = equipment.name
		
	slot = setSlot
	pass

func _on_select_pressed() -> void:
	select.emit(slot)
