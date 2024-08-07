extends CanvasLayer

@export var abilityButton : PackedScene

@onready var AbilityContainer = $VBoxContainer

signal on_button_pressed()

func delete_buttons():
	AbilityContainer.visible = false
	for item in AbilityContainer.get_children():
		item.queue_free()

func create_buttons(abilityList : Array[Node]):
	AbilityContainer.visible = false
	for item in abilityList:
		var newButton = abilityButton.instantiate()
		AbilityContainer.add_child(newButton)
		newButton.initialize(item)
		newButton.pressed.connect(button_pressed)
	AbilityContainer.visible = true

func button_pressed(ability):
	on_button_pressed.emit(ability)
	pass
