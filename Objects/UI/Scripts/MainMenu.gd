extends Control

@export var partyStatblock : PackedScene

@onready var Stats = $PanelContainer/HBoxContainer/Stats
@onready var btnItem = $PanelContainer/HBoxContainer/Buttons/Items
@onready var btnEquipment = $PanelContainer/HBoxContainer/Buttons/Equipment
@onready var btnClose = $PanelContainer/HBoxContainer/Buttons/Close

signal close
signal changeMenu

func initialize(player : Node):
	for item in Stats.get_children():
		item.queue_free()
		
	for item in player.PartyMembers:
		var newStatblock = partyStatblock.instantiate()
		Stats.add_child(newStatblock)
		newStatblock.initialize(item)

func _on_close_pressed():
	close.emit()

func _on_items_pressed():
	changeMenu.emit("inventory")
	pass

func _on_equipment_pressed():
	changeMenu.emit("equipment")
	pass
