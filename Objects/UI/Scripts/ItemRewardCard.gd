extends PanelContainer

@onready var ItemContainer = $MarginContainer/VBoxContainer/ItemContainer
@onready var Inventory = $InventoryComponent
@onready var lblMoney = $MarginContainer/VBoxContainer/MoneyObtained

@export var ItemUI : PackedScene

func initialize(items: Array[ItemResource], money: int):
	Inventory.initialize(items)
	
	for item in Inventory.get_children():
		var newItemUI = ItemUI.instantiate()
		ItemContainer.add_child(newItemUI)
		newItemUI.initialize(item)
	
	lblMoney.text = str(money)
