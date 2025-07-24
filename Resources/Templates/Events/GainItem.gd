class_name GainItem extends EventResource

@export var obtainItemDialogue : DialogueResource = load("res://Assets/Dialogue/ObtainItem.dialogue")
@export var itemData : ItemResource
@export var itemQuantity : int

func process_event():
	for i in itemQuantity:
		Player.Inventory.add_item(itemData)
	create_message()
	pass

func create_message():
	#var options : Dictionary = {"OK": Game.end_interact}
	#UI.create_dialogue(null, "You found " + str(itemQuantity) + " " + itemData.name, options)
	
	DialogueState.add_data("quantity", str(itemQuantity))
	DialogueState.add_data("name", itemData.name)
	DialogueManager.dialogue_ended.connect(end_dialogue)
	UI.create_dialogue(obtainItemDialogue)
	pass

func end_dialogue(_r):
	end_event()
