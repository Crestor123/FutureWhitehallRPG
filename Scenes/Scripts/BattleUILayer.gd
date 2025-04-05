extends Control

@export var abilityButton : PackedScene

@export var allyStatBlock : PackedScene
@export var enemyStatBlock : PackedScene

@export var battlerTurnIcon : PackedScene

@export var damageNumber : PackedScene

@onready var rightBar = $RightBar
@onready var bottomBar = $BottomBar
@onready var leftBar = $LeftBar

@onready var AbilityContainer = $RightBar/ScrollContainer/AbilityContainer
@onready var EnemyStats = $BottomBar/HBoxContainer/MarginContainer/EnemyStats
@onready var AllyStats = $BottomBar/HBoxContainer/MarginContainer2/AllyStats
@onready var TurnOrder = $LeftBar/TurnOrder
@onready var Cursor = $Cursor

signal on_button_pressed()
signal item()
signal inventory()
signal back()
signal switchTargets()

#Deletes any ability buttons and hides the ability menu
func delete_buttons():
	#AbilityContainer.visible = false
	rightBar.visible = false
	Cursor.visible = false
	for item in AbilityContainer.get_children():
		item.queue_free()

#Creates ability buttons for the current battler
func create_ability_buttons(partyMember : Node, inventory : Node, abilityList : Array[Node]):
	for i in AbilityContainer.get_children():
		i.queue_free()
	rightBar.visible = false
	#AbilityContainer.visible = false
	Cursor.visible = false
	var itemButton = abilityButton.instantiate()
	AbilityContainer.add_child(itemButton)
	itemButton.set_label("Item")
	itemButton.data = "item"
	itemButton.pressed.connect(button_pressed)
	
	for item in abilityList:
		var newButton = abilityButton.instantiate()
		AbilityContainer.add_child(newButton)
		newButton.initialize(item)
		newButton.pressed.connect(button_pressed)
		#Check if the party member has sufficient mana or charge
		if partyMember.Stats.get_mana() < item.manaCost:
			newButton.button.disabled = true
		if inventory.CurrentCharge < item.ammoCost:
			newButton.button.disabled = true
		
	#AbilityContainer.visible = true
	rightBar.visible = true
	#Cursor.visible = true

func create_target_buttons(targetList : Array[Node], allies : bool = false, multi : bool = false, targetSelf : bool = false):
	for i in AbilityContainer.get_children():
		i.queue_free()
	
	var backButton = abilityButton.instantiate()
	AbilityContainer.add_child(backButton)
	backButton.set_label("Back")
	backButton.data = "back"
	backButton.pressed.connect(button_pressed)
	
	if !targetSelf:
		var switchButton = abilityButton.instantiate()
		AbilityContainer.add_child(switchButton)
		switchButton.data = "switch"
		switchButton.pressed.connect(button_pressed)
		if allies:
			switchButton.set_label("Enemies")
		else:
			switchButton.set_label("Allies")
	
	if multi:
		var allButton = abilityButton.instantiate()
		AbilityContainer.add_child(allButton)
		allButton.set_label("All")
		allButton.data = "all"
		allButton.pressed.connect(button_pressed)
		return
		
	for target in targetList:
		if target.Stats.dead:
			continue
		var newButton = abilityButton.instantiate()
		AbilityContainer.add_child(newButton)
		if allies:
			newButton.set_label(target.Name)
		else:
			newButton.set_label(target.Name + " " + target.suffix)
		newButton.data = target
		newButton.pressed.connect(button_pressed)
	pass

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

func set_turnorder(battlerList : Array[Node]):
	for item in TurnOrder.get_children():
		item.queue_free()
	
	for item in battlerList:
		var newIcon = battlerTurnIcon.instantiate()
		TurnOrder.add_child(newIcon)
		newIcon.texture = item.icon
	TurnOrder.move_child(TurnOrder.get_node("HSeparator"), TurnOrder.get_child_count())

func remove_statblock(battler : Node):
	pass

func move_cursor(target : Node):
	var targetPos = target.global_position
	Cursor.global_position = Vector2(targetPos.x, targetPos.y - 32)
	pass

func show_inventory(inventory : Node):
	for i in AbilityContainer.get_children():
		i.queue_free()
	
	var backButton = abilityButton.instantiate()
	AbilityContainer.add_child(backButton)
	backButton.set_label("Back")
	backButton.data = "back"
	backButton.pressed.connect(button_pressed)
	
	for item in inventory.get_children():
		if !item is ConsumableNode: continue
		var itemButton = abilityButton.instantiate()
		AbilityContainer.add_child(itemButton)
		itemButton.initialize(item)
		itemButton.pressed.connect(use_item)
	pass

func use_item(itemNode : ItemNode):
	item.emit(itemNode)
	pass

#Called when an ability button is pressed
#Sends a signal to the battler to use the ability
func button_pressed(ability):
	if ability is Node:
		on_button_pressed.emit(ability)
	elif ability == "item":
		inventory.emit()
	elif ability == "back":
		back.emit()
	elif ability == "switch":
		switchTargets.emit()
	pass
