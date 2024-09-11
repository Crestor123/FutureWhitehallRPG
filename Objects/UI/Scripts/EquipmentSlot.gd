extends Control

@onready var Icon = $HBoxContainer/Icon
@onready var lblName = $HBoxContainer/Name
@onready var btnSelect = $Select

var slot
var data : EquipNode

signal selectData
signal selectSlot

func set_slot(setSlot : String):
	lblName.text = setSlot.capitalize()
	slot = setSlot

func set_equipment(equipment : EquipNode, showOwner : bool = false):
	slot = equipment.slot
	lblName.text = equipment.itemName
	Icon.texture = equipment.icon
	lblName.text = equipment.itemName
	
	data = equipment
	if showOwner: show_owner()

func show_owner():
	if data.Owner:
		lblName.text = data.itemName + " (E)"
	pass

func _on_select_pressed() -> void:
	if data:
		selectData.emit(data)
	if slot:
		selectSlot.emit(slot)
