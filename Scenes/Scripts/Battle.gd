extends Node2D

@onready var TurnOrder = $TurnOrder
@onready var UI = $UILayer/BattleUI
@onready var T = $Timer

@export var allyScene : PackedScene
@export var enemyScene : PackedScene

var allies : Array[Node]
var enemies : Array[Node]

var allyColumn = 272
var enemyColumn = 112

var currentBattler : Node = null
var currentTarget : Node = null

signal battleFinished()
signal battleLoss()

func initialize(partyMembers : Array[PartyMember], enemyFormation : EnemyFormation):
	#Takes a list of party members and enemies
	#Creates a battler node for each of them
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

func move_cursor(target : Node):
	currentTarget = target
	UI.move_cursor(target)
	pass

func start_battle():
	while !enemies.is_empty():
		#Start of round:
		TurnOrder.sort_turn_order()	#Sort turn order
		UI.set_turnorder(TurnOrder.Round)
		print("Start of Round")
		while !TurnOrder.Round.is_empty():
			print("Start of Turn")
			currentBattler = TurnOrder.get_next_battler()
			
			if currentBattler in allies:
				#The current battler is an ally; show the ability selection UI
				UI.create_buttons(currentBattler.Abilities.get_children())
				UI.move_cursor(enemies[0])
				currentTarget = enemies[0]
				UI.on_button_pressed.connect(ability_button)
				await currentBattler.Abilities.used_ability
				UI.delete_buttons()
				UI.on_button_pressed.disconnect(ability_button)
				T.wait_time = 1
				T.start()
				await T.timeout
			
			else:
				#The current battler is an enemy
				currentBattler.start_turn(TurnOrder.RoundCount)
				T.wait_time = 1
				T.start()
				await T.timeout
			
			print("End Turn")
		print("End Round")
	if enemies.is_empty():	#Victory, return to previous map
		battleFinished.emit()
		

func battler_defeated(battler):
	#Remove battler from turn order
	if battler in enemies:
		enemies.erase(battler)
	elif battler in allies:
		allies.erase(battler)
		
	TurnOrder.remove_battler(battler)
