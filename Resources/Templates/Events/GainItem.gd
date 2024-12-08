class_name GainItem extends EventResource

@export var itemData : ItemResource
@export var itemQuantity : int

func process_event():
	for i in itemQuantity:
		Player.Inventory.add_item(itemData)
	pass

func create_message():
	pass
