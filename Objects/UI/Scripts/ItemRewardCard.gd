extends PanelContainer

@onready var ItemContainer = $MarginContainer/VBoxContainer/ItemContainer
@onready var Inventory = $InventoryComponent

@export var ItemUI : PackedScene

func initialize(items: Array[ItemResource]):
	Inventory.initialize(items)
	
	for item in Inventory.get_children():
		var newItemUI = ItemUI.instantiate()
		ItemContainer.add_child(newItemUI)
		newItemUI.initialize(item)
	pass
