extends Node2D

@onready var TurnOrder = $TurnOrder
@onready var UI = $UILayer

@export var allyScene : PackedScene
@export var enemyScene : PackedScene

var allies : Array[Node]
var enemies : Array[Node]

var allyColumn = 272
var enemyColumn = 112

var currentBattler : Node = null

signal combatFinished()
signal combatLoss()

func initialize(partyMembers : Array[PartyMember], enemyFormation : EnemyFormation):
	#Takes a list of party members and enemies
	#Creates a battler node for each of them
	for item in partyMembers:
		var newAlly = allyScene.instantiate()
		TurnOrder.add_child(newAlly)
		allies.append(newAlly)
		newAlly.partyMember = item
		newAlly.initialize()
		
	for item in enemyFormation.enemyList:
		var newEnemy = enemyScene.instantiate()
		TurnOrder.add_child(newEnemy)
		enemies.append(newEnemy)
		newEnemy.data = item
		newEnemy.initialize()
		
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
	currentBattler.Abilities.use_ability(ability, enemies[0])

func start_battle():
	while !enemies.is_empty():
		#Start of round:
		TurnOrder.sort_turn_order()	#Sort turn order
		while !TurnOrder.Round.is_empty():
			currentBattler = TurnOrder.get_next_battler()
			
			if currentBattler in allies:
				#The current battler is an ally; show the ability selection UI
				UI.create_buttons(currentBattler.Abilities.get_children())
				UI.on_button_pressed.connect(ability_button)
				await currentBattler.Abilities.used_ability
				
			UI.delete_buttons()
			UI.on_button_pressed.disconnect(ability_button)
	pass
