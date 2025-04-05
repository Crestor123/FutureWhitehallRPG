extends Node2D

@onready var TurnOrder = $TurnOrder
@onready var UI = $UILayer/BattleUI
@onready var T = $Timer

@export var allyScene : PackedScene
@export var enemyScene : PackedScene

var allies : Array[Node]
var enemies : Array[Node]
var inventory : Node

var finishedAnimations = false
var victory = false
var defeat = false

var allyColumn = 272	#Coordinates for placing allies
var enemyColumn = 112

var currentBattler : Node = null
var currentTarget : Node = null
var currentAbility : Node = null
var currentItem : Node = null
var currentMenu : String = ""
var targetingAllies : bool = false

signal startTurn()	#
signal endTurn()	#Emitted after processing the current battler's turn
signal endRound()
signal battleWon()
signal battleLoss()

func initialize(partyMembers : Array[PartyMember], enemyFormation : EnemyFormation, setInventory):
	#Takes a list of party members and enemies
	#Creates a battler node for each of them
	startTurn.connect(start_turn)
	endRound.connect(start_round)
	
	inventory = setInventory
	
	for item in partyMembers:
		var newAlly = allyScene.instantiate()
		TurnOrder.add_child(newAlly)
		allies.append(newAlly)
		newAlly.partyMember = item
		newAlly.initialize()
		newAlly.on_select.connect(move_cursor)
		newAlly.dead.connect(battler_defeated)
		
	for item in enemyFormation.enemyList:
		var newEnemy = enemyScene.instantiate()
		TurnOrder.add_child(newEnemy)
		enemies.append(newEnemy)
		newEnemy.data = item
		newEnemy.initialize()
		newEnemy.on_select.connect(move_cursor)
		newEnemy.dead.connect(battler_defeated)
	
	#Give the enemies references to the lists of battlers
	#For duplicate enemies, set the suffix
	for item in enemies:
		item.allies = enemies
		item.targets = allies
		
		var dupe = false
		for other in enemies:
			if other != self && other.Name == item.Name:
				dupe = true
				break
		
		#Start at A and loop through alphabet
		#Hopefully never have more than 26 of the same enemy in a combat
		var suffix = "A"
		if dupe:
			for other in enemies:
				if other.Name == item.Name:
					other.suffix = suffix
					suffix[0] = String.chr(suffix.unicode_at(0) + 1)
		
	#Initialize the UI
	UI.initialize_statblocks(allies, enemies)
	
	#Position each battler on the field
	position_battlers()
	start_battle()

func position_battlers():
	var id = 0
	for item in allies:
		item.global_position = Vector2(allyColumn, 48 + 32 * id)
		id += 1
		
	id = 0
	for item in enemies:
		item.global_position = Vector2(enemyColumn, 48 + 32 * id)
		id += 1
	pass

func ability_button(ability : Node):
	currentAbility = ability
	var multi = ability.target == "multi"
	var targetingSelf = ability.target == "self"
	targetingAllies = false
	ui_show_targets(targetingAllies, multi, targetingSelf)

func item_button(item : Node):
	currentItem = item
	var multi = item.targetAll
	targetingAllies = true
	ui_show_targets(targetingAllies, multi)

func target_button(target : Node = null):
	var ability = currentAbility
	var item = currentItem
	
	if target == null:
		#The ability targets all allies / enemies
		if targetingAllies:
			currentBattler.Abilities.use_ability(ability, allies)
		else:
			currentBattler.Abilities.use_ability(ability, enemies)
	else:
		currentTarget = target
		var targetArray : Array[Node] = [currentTarget]
		if ability:
			currentBattler.Abilities.use_ability(ability, targetArray)
		elif item:
			use_item(item)
	pass

func use_item(item : ConsumableNode):
	if item.targetAll:
		if currentTarget in allies:
			inventory.use_item(item, allies)
		else:
			inventory.use_item(item, enemies)
	else:
		var targetArray : Array[Node] = [currentTarget]
		inventory.use_item(item, targetArray)
	currentBattler.end_turn()

func move_cursor(target : Node):
	currentTarget = target
	UI.move_cursor(target)
	pass

func start_battle():
	start_round()
	
func start_round():
	TurnOrder.sort_turn_order()			#Sort the turn order
	UI.set_turnorder(TurnOrder.Round)	#Display the turn order in the UI
	startTurn.emit()					#Start the turn
	pass

func start_turn():
	print("Start of Turn")
	if victory or defeat:
		return
			
	currentBattler = TurnOrder.get_next_battler()
	
	if currentBattler in allies:
		#The current battler is an ally; show the ability selection UI
		ui_show_abilities()
		for i in enemies:
			if !i.Stats.dead:
				UI.move_cursor(i)
				currentTarget = i
				break

		UI.inventory.connect(ui_show_inventory)
		currentBattler.endTurn.connect(end_turn)
		currentBattler.start_turn()
	else:
		currentBattler.endTurn.connect(end_turn)
		currentBattler.start_turn(TurnOrder.RoundCount)
	pass

func end_turn():
	#Wait for any animations to finish
	finishedAnimations = false
	while finishedAnimations == false:
		finishedAnimations = true
		for ally in allies:
			if ally.playingAnimation:
				finishedAnimations = false
		for enemy in enemies:
			if enemy.playingAnimation:
				finishedAnimations = false
	
	#Disconnect any UI buttons for the current ally
	if currentBattler in allies:
		UI.delete_buttons()
		UI.on_button_pressed.disconnect(ability_button)
	
	#Disconnect the current battler from the turn flow
	currentBattler.endTurn.disconnect(end_turn)
	
	T.wait_time = 1		#Short delay
	T.start()
	await T.timeout

	currentAbility = null
	currentItem = null

	#Check for victory or defeat
	if victory:	 #return to previous map
		tally_rewards()
		
	if defeat:
		#Game over
		battleLoss.emit()
		
	if TurnOrder.Round.is_empty():
		print("End Round")
		endRound.emit()
	else:
		print("End Turn")
		endTurn.emit()
		startTurn.emit()
	
func ui_show_abilities():
	currentAbility = null
	UI.on_button_pressed.disconnect(target_button)
	UI.on_button_pressed.connect(ability_button)
	currentMenu = "ability"
	UI.create_ability_buttons(currentBattler, inventory, currentBattler.Abilities.get_children())
	pass
		
func ui_show_targets(targetingAllies : bool = false, multi : bool = false, targetSelf : bool = false):
	#After selecting an ability, show a list of possible targets
	#By default, shows a list of enemies, with no "all enemies" button
	UI.on_button_pressed.disconnect(ability_button)
	UI.on_button_pressed.connect(target_button)
	if currentMenu == "ability":
		UI.back.connect(ui_show_abilities)
	if currentMenu == "inv":
		UI.back.connect(ui_show_inventory)
	UI.switchTargets.connect(ui_switch_targets)
	var targetList : Array[Node] = enemies
	if targetingAllies:
		targetList = allies
	if targetSelf:
		targetList = [currentBattler]
	UI.create_target_buttons(targetList, targetingAllies, multi, targetSelf)

	pass

func ui_switch_targets():
	var multi = false
	if currentAbility:
		multi = currentAbility.target == "multi"
	elif currentItem:
		multi = currentItem.targetAll
	targetingAllies = !targetingAllies
	ui_show_targets(targetingAllies, multi)
	pass

func ui_show_inventory():
	currentItem = null
	currentMenu = "inv"
	UI.show_inventory(inventory)
	UI.back.connect(ui_show_abilities)
	UI.item.connect(item_button)
	pass

func tally_rewards():
	#Tally up experience points
	#Roll to see if any items are dropped
	var experience : Array
	var itemDrops : Array[ItemResource]
	for enemy in enemies:
		if enemy.Stats.dead:
			experience.append([enemy.level, enemy.experience])
			for item in enemy.itemDrops:
				var rand = randi_range(1, 100)
				if rand < enemy.itemDrops[item]:
					itemDrops.append(item)
	battleWon.emit(experience, itemDrops)
	pass

func battler_defeated(battler):
	#Remove battler from turn order
	TurnOrder.remove_battler(battler)
	
	#Check if the battler was the last ally or enemy
	victory = true
	for item in enemies:
		if !item.Stats.dead: victory = false
		
	defeat = true
	for item in allies:
		if !item.Stats.dead: defeat = false
