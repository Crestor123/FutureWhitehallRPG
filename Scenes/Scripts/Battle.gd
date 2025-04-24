extends Node2D

@onready var TurnOrder = $TurnOrder
@onready var UI = $UILayer/BattleUI
@onready var T = $Timer

@export var allyScene : PackedScene
@export var enemyScene : PackedScene

enum UI_STATE {ABILITY, ITEM, TARGET}

var allies : Array[Battler]
var enemies : Array[Battler]
var analyzedBattlers: Array[Battler]
var readyBattlers: Array[Battler]
var uiState: Array[UI_STATE]
var inventory : Node

#Used for end of battle reward tallying
var experience : Array
var expTotal : int
var itemDrops : Array[ItemResource]

var turnReady = false
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
signal resetTurn()
signal battleWon()
signal battleLoss()

func initialize(partyMembers : Array[PartyMember], enemyFormation : EnemyFormation, setInventory):
	#Takes a list of party members and enemies
	#Creates a battler node for each of them
	startTurn.connect(start_turn)
	endRound.connect(start_round)
	resetTurn.connect(reset_turn)
	
	UI.switchTargets.connect(ui_switch_targets)
	UI.item.connect(ui_change_state)
	UI.inventory.connect(ui_change_state)
	UI.on_button_pressed.connect(ui_change_state)
	UI.back.connect(ui_pop_state)
	
	inventory = setInventory
	
	for item in partyMembers:
		var newAlly = allyScene.instantiate()
		TurnOrder.add_child(newAlly)
		allies.append(newAlly)
		newAlly.partyMember = item
		newAlly.initialize()
		newAlly.on_select.connect(move_cursor)
		newAlly.analyzed.connect(immediate_analyze_battler)
		newAlly.dead.connect(battler_defeated)
		newAlly.battlerReady.connect(ready_check)
		
	for item in enemyFormation.enemyList:
		var newEnemy = enemyScene.instantiate()
		TurnOrder.add_child(newEnemy)
		enemies.append(newEnemy)
		newEnemy.data = item
		newEnemy.initialize()
		newEnemy.on_select.connect(move_cursor)
		newEnemy.analyzed.connect(immediate_analyze_battler)
		newEnemy.dead.connect(battler_defeated)
		newEnemy.battlerReady.connect(ready_check)
	
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
	var targetSelf = ability.target == "self"
	targetingAllies = false
	if ability.targetAllies:
		targetingAllies = true
	ui_show_targets(targetingAllies, multi, targetSelf, ability.swapTargets)

func item_button(item : Node):
	currentItem = item
	var multi = item.targetAll
	targetingAllies = false
	if item.targetAllies:
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
			UI.set_topBar(ability.abilityName)
			currentBattler.Abilities.use_ability(ability, targetArray)
		elif item:
			use_item(item)
	pass

func use_item(item : ConsumableNode):
	UI.set_topBar(item.itemName)
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
		uiState.append(UI_STATE.ABILITY)
		ui_show_abilities()

		currentBattler.endTurn.connect(end_turn)
		#currentBattler.Abilities.analyze.connect(analyze_battler)
		currentBattler.start_turn(TurnOrder.RoundCount)
	else:
		currentBattler.selectedAbility.connect(UI.set_topBar)
		currentBattler.endTurn.connect(end_turn)
		currentBattler.start_turn(TurnOrder.RoundCount)
	pass

func end_turn():
	turnReady = false
	for item in allies:
		item.ready_check()
	for item in enemies:
		item.ready_check()
	
	#Disconnect any UI buttons for the current ally
	if currentBattler in allies:
		UI.delete_buttons()
		#UI.on_button_pressed.disconnect(ability_button)
	
	#Disconnect the current battler from the turn flow
	currentBattler.endTurn.disconnect(end_turn)

	currentAbility = null
	currentItem = null
	
	T.wait_time = 1.2		#Short delay
	T.start()
	await T.timeout
	
	#If there are battlers to be analyzed, do so
	while !analyzedBattlers.is_empty():
		ui_show_statblock(analyzedBattlers[0])
		await UI.closeStatblock
		analyzedBattlers.pop_front()
	
	turnReady = true
	ready_check()

func ready_check(battler: Battler = null):
	if battler:
		readyBattlers.append(battler)
	
	for item in allies:
		if !readyBattlers.has(item):
			return
	for item in enemies:
		if !readyBattlers.has(item):
			return

	if turnReady:
		turnReady = false
		readyBattlers = []
		resetTurn.emit()
	pass

func reset_turn():
	readyBattlers = []
	
	#Check for victory or defeat
	if victory:	 #return to previous map
		tally_rewards()
		
	if defeat:
		#Game over
		end_battle()
		
	if TurnOrder.Round.is_empty():
		print("End Round")
		endRound.emit()
	else:
		print("End Turn")
		endTurn.emit()
		startTurn.emit()

func ui_change_state(data: Node = null):
	if uiState.is_empty():
		uiState.append(UI_STATE.ABILITY)
	
	match uiState[-1]:
		UI_STATE.ABILITY:
			if data == null:
				#Triggers when the item button is pressed
				uiState.append(UI_STATE.ITEM)
				ui_show_inventory()
			else:
				uiState.append(UI_STATE.TARGET)
				ability_button(data)
		UI_STATE.ITEM:
			uiState.append(UI_STATE.TARGET)
			item_button(data)
		UI_STATE.TARGET:
			uiState.clear()
			target_button(data)
	pass
	
func ui_pop_state():
	if uiState.size() <= 1:
		return
	uiState.pop_back()
	
	match uiState[-1]:
		UI_STATE.ABILITY:
			ui_show_abilities()
		UI_STATE.ITEM:
			ui_show_inventory()
	pass

func ui_show_abilities():
	currentAbility = null
	currentMenu = "ability"
	UI.create_ability_buttons(currentBattler, inventory, currentBattler.Abilities.get_children())
	pass
		
func ui_show_targets(targetingAllies : bool = false, multi : bool = false, targetSelf : bool = false, swapTargets : bool = true):
	#After selecting an ability, show a list of possible targets
	#By default, shows a list of enemies, with no "all enemies" button
	var targetList : Array[Battler] = enemies
	if targetingAllies:
		targetList = allies
	if targetSelf:
		targetList = [currentBattler]
	UI.create_target_buttons(targetList, targetingAllies, multi, swapTargets)

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
	pass

func analyze_battler(battler: Battler):
	analyzedBattlers.append(battler)
	
func immediate_analyze_battler(battler: Battler):
	UI.disable_buttons()
	ui_show_statblock(battler)
	await UI.closeStatblock
	UI.enable_buttons()

func ui_show_statblock(battler: Battler):
	UI.show_statblock(battler)

func tally_rewards():
	#Tally up experience points
	#Roll to see if any items are dropped
	for enemy in enemies:
		if enemy.Stats.dead:
			expTotal += enemy.experience
			experience.append([enemy.level, enemy.experience])
			for item in enemy.itemDrops:
				var rand = randi_range(1, 100)
				if rand < enemy.itemDrops[item]:
					print("Gained item ", item)
					itemDrops.append(item)
	
	UI.show_levelup_cards(allies, expTotal)
	UI.xpCardsDone.connect(xp_cards_done)
	pass

func xp_cards_done():
	UI.btnContinue.pressed.connect(end_battle)
	pass

func end_battle():
	if defeat:
		battleLoss.emit()
	elif victory:
		battleWon.emit(experience, itemDrops)

func battler_defeated(battler: Battler):
	#Remove battler from turn order
	TurnOrder.remove_battler(battler)
	
	#Check if the battler was the last ally or enemy
	victory = true
	for item in enemies:
		if !item.Stats.dead: victory = false
		
	defeat = true
	for item in allies:
		if !item.Stats.dead: defeat = false
