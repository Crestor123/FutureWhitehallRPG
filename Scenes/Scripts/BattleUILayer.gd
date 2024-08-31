extends Control

@export var abilityButton : PackedScene
@export var allyStatBlock : PackedScene
@export var enemyStatBlock : PackedScene

@onready var rightBar = $RightBar
@onready var bottomBar = $BottomBar
@onready var leftBar = $LeftBar

@onready var AbilityContainer = $RightBar/AbilityContainer
@onready var EnemyStats = $BottomBar/HBoxContainer/MarginContainer/EnemyStats
@onready var AllyStats = $BottomBar/HBoxContainer/MarginContainer2/AllyStats
@onready var TurnOrder = $LeftBar/TurnOrder
@onready var Cursor = $Cursor

signal on_button_pressed()

func delete_buttons():
	#AbilityContainer.visible = false
	rightBar.visible = false
	Cursor.visible = false
	for item in AbilityContainer.get_children():
		item.queue_free()

func create_buttons(abilityList : Array[Node]):
	rightBar.visible = false
	#AbilityContainer.visible = false
	Cursor.visible = false
	for item in abilityList:
		var newButton = abilityButton.instantiate()
		AbilityContainer.add_child(newButton)
		newButton.initialize(item)
		newButton.pressed.connect(button_pressed)
	#AbilityContainer.visible = true
	rightBar.visible = true
	Cursor.visible = true

func initialize_statblocks(allyList : Array[Node], enemyList : Array[Node]):
	for item in allyList:
		var newStatBlock = allyStatBlock.instantiate()
		AllyStats.add_child(newStatBlock)
		newStatBlock.initialize(item)
		item.Stats.healthChanged.connect(newStatBlock.update_health)
		
	for item in enemyList:
		var newStatBlock = enemyStatBlock.instantiate()
		EnemyStats.add_child(newStatBlock)
		newStatBlock.initialize(item)
	pass

func move_cursor(target : Node):
	var targetPos = target.global_position
	Cursor.global_position = Vector2(targetPos.x, targetPos.y - 32)
	pass

func button_pressed(ability):
	on_button_pressed.emit(ability)
	pass
