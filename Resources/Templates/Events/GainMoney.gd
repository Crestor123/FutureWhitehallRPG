class_name GainMoney extends EventResource

@export var amount : int

func process_event():
	Player.Inventory.add_money(amount)
	create_message()
	pass

func create_message():
	var options : Dictionary = {"OK": Game.end_interact}
	UI.create_dialog(null, "You found " + str(amount) + " coins!", options)
	pass
