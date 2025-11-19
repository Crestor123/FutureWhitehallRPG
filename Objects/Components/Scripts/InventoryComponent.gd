extends Node

@export var itemScene : PackedScene
@export var equipmentScene : PackedScene
@export var consumableScene : PackedScene
@export var firearmScene : PackedScene
@export var casterPartScene : PackedScene
@export var spellCardScene : PackedScene

@export var TotalCharge : int = 100
@export var CurrentCharge : int = 100

@export var Money : int = 0

signal itemChanged(item)
signal itemRemoved(item)

func initialize(itemList : Array[ItemResource]):
	for item in itemList:
		add_item(item)
	pass
	
func add_money(amount):
	Money += amount
	
func remove_money(amount):
	Money -= amount
	if Money < 0:
		Money = 0
	
func use_item(item : ItemNode, targetList : Array[Node]):
	for target in targetList:
		print("Using item ", item.itemName, " on ", target.name)
	
	if item.bonus != 0:
		if item.stat == "health":
			for target in targetList:
				target.Stats.take_damage(-item.bonus, "none", item.element)
		elif item.stat == "mana":
			for target in targetList:
				target.tempStats["mana"] += item.bonus
	
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
	if item is FirearmResource:
		newItem = firearmScene.instantiate()
	elif item is EquipResource:
		newItem = equipmentScene.instantiate()
	elif item is ConsumableResource:
		newItem = consumableScene.instantiate()
	elif item is CasterPartResource:
		newItem = casterPartScene.instantiate()
	elif item is SpellCardResource:
		newItem = spellCardScene.instantiate()
	else:
		newItem = itemScene.instantiate()
		
	add_child(newItem)
	newItem.data = item
	newItem.initialize()
	
	if newItem.id == "battery":
		TotalCharge += 50
		CurrentCharge += 50
		
	return newItem
	
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
