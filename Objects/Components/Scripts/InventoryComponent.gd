extends Node

@export var itemScene : PackedScene
@export var equipmentScene : PackedScene
@export var consumableScene : PackedScene

signal itemChanged(item)
signal itemRemoved(item)

func initialize(itemList : Array[ItemResource]):
	for item in itemList:
		add_item(item)
	pass
	
func use_item(item : ItemNode, partyMember : PartyMember):
	print("Using item ", item.itemName, " on ", partyMember.partyName)
	if item.stackable and item.quantity > 1:
		item.quantity -= 1
	else:
		remove_item(item)
	itemChanged.emit(item)
	pass
	
func add_item(item : ItemResource):
	if item.stackable:
		var stackableItem = in_inventory(item)
		if stackableItem:
			stackableItem.quantity += item.quantity
			return
	
	var newItem : Node = null
	if item is EquipResource:
		newItem = equipmentScene.instantiate()
	if item is ConsumableResource:
		newItem = consumableScene.instantiate()
	else:
		newItem = itemScene.instantiate()
		
	add_child(newItem)
	newItem.data = item
	newItem.initialize()
	
func remove_item(item : Node):
	itemRemoved.emit(item)
	item.queue_free()
	pass
	
func transfer_item(item : Node, destination : Node):
	item.reparent(destination)
	pass
	
func in_inventory(item : ItemResource) -> ItemNode:
	for child in get_children():
		if child.data == item:
			return child
	return null
	pass
