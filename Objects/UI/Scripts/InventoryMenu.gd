extends Control

@export var ItemUI : PackedScene
@export var PartySelector : PackedScene

@onready var ItemContainer = $PanelContainer/VBoxContainer/ItemContainer
@onready var Description = $PanelContainer/VBoxContainer/HBoxContainer2/MarginContainer/Description

signal close
signal back
signal useItem

var selectedItem : ItemNode = null
var partySelector : Node = null

func initialize(player : Node):
	var inventory = player.Inventory
	useItem.connect(inventory.use_item)
	inventory.itemChanged.connect(update_item)
	inventory.itemRemoved.connect(remove_item)
	for item in inventory.get_children():
		var newItem = ItemUI.instantiate()
		ItemContainer.add_child(newItem)
		newItem.select.connect(item_selected)
		newItem.initialize(item)
	pass

func update_item(itemChanged : ItemNode):
	print("Updating item ", itemChanged.itemName)
	for item in ItemContainer.get_children():
		if item.data == itemChanged:
			item.initialize(itemChanged)

func remove_item(itemRemoved : ItemNode):
	for item in ItemContainer.get_children():
		if item.data == itemRemoved:
			item.queue_free()
			
	Description.text = ""
			
	if partySelector:
		partySelector.queue_free()
		partySelector = null
		selectedItem = null

func item_selected(itemData : ItemNode):
	selectedItem = itemData
	Description.text = selectedItem.description
	pass

func select_partyMember(partyMember : PartyMember):
	useItem.emit(selectedItem, partyMember)

func _on_back_pressed():
	back.emit()

func _on_close_pressed():
	close.emit()

func _on_use_pressed():
	if selectedItem:
		partySelector = PartySelector.instantiate()
		add_child(partySelector)
		partySelector.initialize(get_parent().Player.PartyMembers)
		partySelector.select.connect(select_partyMember)
