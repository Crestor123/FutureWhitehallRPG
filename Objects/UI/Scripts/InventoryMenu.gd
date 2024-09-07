extends Control

@export var ItemUI : PackedScene

@onready var ItemContainer = $PanelContainer/VBoxContainer/ItemContainer

signal close
signal back

func initialize(player : Node):
	var inventory = player.Inventory
	for item in inventory.get_children():
		var newItem = ItemUI.instantiate()
		ItemContainer.add_child(newItem)
		newItem.initialize(item)
	pass

func _on_back_pressed():
	back.emit()
