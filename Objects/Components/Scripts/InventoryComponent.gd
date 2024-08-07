extends Node

@export var itemScene : PackedScene
@export var equipmentScene : PackedScene
@export var consumableScene : PackedScene

func initialize(itemList : Array[Node]):
	pass
	
func use_item(item : Node, partyMember : PartyMember):
	pass
	
func add_item(item : Node):
	pass
	
func remove_item(item : Node):
	pass
	
func transfer_item(item : Node, destination : Node):
	pass
	
func in_inventory(item : Node):
	#Returns if a given item is in the inventory
	pass
