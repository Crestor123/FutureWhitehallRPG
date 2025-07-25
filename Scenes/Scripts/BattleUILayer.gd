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
@onready var LevelUpCardContainer = $MarginContainer2/LevelUpCardContainer
@onready var ItemRewardCard = $MarginContainer3/ItemRewardCard
@onready var EnemyStats = $BottomBar/HBoxContainer/MarginContainer/EnemyStats
@onready var AllyStats = $BottomBar/HBoxContainer/MarginContainer2/AllyStats
@onready var TurnOrder = $LeftBar/TurnOrder
@onready var topBar = $TopBar
@onready var lblMoveName = $TopBar/CenterContainer/lblMoveName
@onready var MoveNameTimer = $TopBar/CenterContainer/lblMoveName/Timer
@onready var Cursor = $Cursor
@onready var DetailStatblock = $DetailStatBlock
@onready var btnContinue = $btnContinue

signal on_button_pressed()
signal item()
signal inventory()
signal back()
signal battle_win_finished()
signal closeStatblock()
signal switchTargets()

#Deletes any ability buttons and hides the ability menu
func delete_buttons():
	#AbilityContainer.visible = false
	rightBar.visible = false
	Cursor.visible = false
	for item in AbilityContainer.get_children():
		item.queue_free()

func disable_buttons():
	for item in AbilityContainer.get_children():
		item.disable_button()
		
func enable_buttons():
	for item in AbilityContainer.get_children():
		item.enable_button()

#Creates ability buttons for the current battler
func create_ability_buttons(partyMember : Battler, inventory : Node, abilityList : Array[Node]):
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

func create_target_buttons(targetList : Array[Battler], allies : bool = false, multi : bool = false, swapTargets : bool = true):
	for i in AbilityContainer.get_children():
		i.queue_free()
	
	var backButton = abilityButton.instantiate()
	AbilityContainer.add_child(backButton)
	backButton.set_label("Back")
	backButton.data = "back"
	backButton.pressed.connect(button_pressed)
	
	if swapTargets:
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

func initialize_statblocks(allyList : Array[Battler], enemyList : Array[Battler]):
	for item in allyList:
		var newStatBlock = allyStatBlock.instantiate()
		AllyStats.add_child(newStatBlock)
		newStatBlock.initialize(item)
		item.Stats.healthChanged.connect(newStatBlock.update_health)
		item.Stats.manaChanged.connect(newStatBlock.update_mana)
		
	for item in enemyList:
		var newStatBlock = enemyStatBlock.instantiate()
		EnemyStats.add_child(newStatBlock)
		newStatBlock.initialize(item)
	pass

func set_turnorder(battlerList : Array[Battler]):
	var separator = TurnOrder.get_node("HSeparator")
	for item in TurnOrder.get_children():
		if item != separator:
			item.queue_free()
	
	for item in battlerList:
		var newIcon = battlerTurnIcon.instantiate()
		TurnOrder.add_child(newIcon)
		newIcon.texture = item.icon
	TurnOrder.move_child(separator, -1)

func remove_statblock(battler : Node):
	pass

func move_cursor(target : Battler):
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

#Set the top bar to show the move or item name
#Start the timer and remove the box after it ends
func set_topBar(moveName : String):
	lblMoveName.text = moveName
	topBar.visible = true
	MoveNameTimer.start()
	pass

func hide_topBar():
	topBar.visible = false
	
#Displays the detailed statblock for the given battler
func show_statblock(battler: Battler):
	DetailStatblock.close.connect(hide_statblock)
	DetailStatblock.initialize(battler.icon, battler.Name, battler.Stats)
	DetailStatblock.visible = true
	pass

func hide_statblock():
	DetailStatblock.visible = false
	closeStatblock.emit()

func battle_win(partyMembers: Array[Battler], expTotal: int, itemDrops: Array[ItemResource], moneyDrop: int):
	LevelUpCardContainer.initialize(partyMembers, expTotal)
	ItemRewardCard.initialize(itemDrops, moneyDrop)
	LevelUpCardContainer.finished.connect(level_up_cards_finished)
	btnContinue.pressed.connect(LevelUpCardContainer.skip)
	
	LevelUpCardContainer.show()
	btnContinue.show()
	pass

func level_up_cards_finished():
	btnContinue.pressed.disconnect(LevelUpCardContainer.skip)
	btnContinue.pressed.connect(show_item_rewards)
	
func show_item_rewards():
	LevelUpCardContainer.hide()
	ItemRewardCard.show()
	btnContinue.pressed.disconnect(show_item_rewards)
	btnContinue.pressed.connect(item_rewards_finished)
	
func item_rewards_finished():
	battle_win_finished.emit()
