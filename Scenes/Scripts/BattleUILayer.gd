extends CanvasLayer

@export var abilityButton : PackedScene

@onready var AbilityContainer = $VBoxContainer
@onready var Cursor = $Cursor

signal on_button_pressed()

func delete_buttons():
	AbilityContainer.visible = false
	Cursor.visible = false
	for item in AbilityContainer.get_children():
		item.queue_free()

func create_buttons(abilityList : Array[Node]):
	AbilityContainer.visible = false
	Cursor.visible = false
	for item in abilityList:
		var newButton = abilityButton.instantiate()
		AbilityContainer.add_child(newButton)
		newButton.initialize(item)
		newButton.pressed.connect(button_pressed)
	AbilityContainer.visible = true
	Cursor.visible = true

func move_cursor(target : Node):
	var targetPos = target.global_position
	Cursor.global_position = Vector2(targetPos.x, targetPos.y - 32)
	pass

func button_pressed(ability):
	on_button_pressed.emit(ability)
	pass
