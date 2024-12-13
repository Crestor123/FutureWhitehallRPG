class_name GainItem extends EventResource

@export var itemData : ItemResource
@export var itemQuantity : int

func process_event():
	for i in itemQuantity:
		Player.Inventory.add_item(itemData)
	create_message()
	pass

func create_message():
	var options : Dictionary = {"OK": Game.end_interact}
	UI.create_dialog(null, "You found " + str(itemQuantity) + " " + itemData.name, options)
	pass
