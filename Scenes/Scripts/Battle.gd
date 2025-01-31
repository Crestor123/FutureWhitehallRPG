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
	for item in enemies:
		item.allies = enemies
		item.targets = allies
		
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
	if ability.target == "multi":
		if currentTarget in allies:
			currentBattler.Abilities.use_ability(ability, allies) 
		else:
			currentBattler.Abilities.use_ability(ability, enemies) 
	else:
		var targetArray : Array[Node] = [currentTarget]
		currentBattler.Abilities.use_ability(ability, targetArray)
		
	await currentTarget.animationFinished

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
		UI.on_button_pressed.connect(ability_button)
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
	UI.create_buttons(currentBattler, inventory, currentBattler.Abilities.get_children())
	pass
		
func ui_show_inventory():
	UI.show_inventory(inventory)
	UI.back.connect(ui_show_abilities)
	UI.useItem.connect(use_item)
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
