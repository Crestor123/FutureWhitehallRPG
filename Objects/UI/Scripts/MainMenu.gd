extends Control

@export var partyStatblock : PackedScene

@onready var Stats = $PanelContainer/HBoxContainer/Stats
@onready var btnItem = $PanelContainer/HBoxContainer/Buttons/Items
@onready var btnEquipment = $PanelContainer/HBoxContainer/Buttons/Equipment
@onready var btnCaster = $PanelContainer/HBoxContainer/Buttons/Caster
@onready var btnClose = $PanelContainer/HBoxContainer/Buttons/Close
@onready var lblMoney = $PanelContainer/HBoxContainer/Buttons/Money

signal close
signal changeMenu

func initialize(player : Node):
	for item in Stats.get_children():
		item.queue_free()
		
	for item in player.PartyMembers:
		var newStatblock = partyStatblock.instantiate()
		Stats.add_child(newStatblock)
		newStatblock.initialize(item)
		
	lblMoney.text = str(player.Inventory.Money)

func _on_close_pressed():
	close.emit()

func _on_items_pressed():
	changeMenu.emit("inventory")
	pass

func _on_equipment_pressed():
	changeMenu.emit("equipment")
	pass
	
func _on_caster_pressed() -> void:
	changeMenu.emit("caster")
