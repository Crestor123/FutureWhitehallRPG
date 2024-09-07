extends Node2D

@onready var UILayer = $UILayer
@onready var UI = $UILayer/OverworldUI
@onready var SceneChanger = $SceneChanger
@onready var Player = $Player

@export var StartingScene : PackedScene
@export var StartingPosition : Vector2

func _ready():
	UI.buttonPressed.connect(ui_button)
	UI.menuButtonPressed.connect(open_menu)
	SceneChanger.load_scene(StartingScene, StartingPosition)
	SceneChanger.encounter.connect(enter_battle)
	Player.initialize()

func ui_button(button : String):
	pass

func enter_battle(enemyFormation):
	print(enemyFormation.enemyList)
	await SceneChanger.load_subscene(SceneChanger.BattleScene)
	UILayer.visible = false
	SceneChanger.CurrentScene.initialize(Player.PartyMembers, enemyFormation)
	SceneChanger.CurrentScene.battleFinished.connect(battle_victory)
	pass

func open_menu(menuState : String):
	await SceneChanger.load_subscene(SceneChanger.PauseMenu)
	SceneChanger.CurrentScene.initialize(menuState, Player)
	SceneChanger.CurrentScene.close.connect(close_menu)
	UILayer.visible = false
	pass

func close_menu():
	SceneChanger.return_from_subscene()
	UILayer.visible = true
	pass

func battle_victory():
	print("Battle won!")
	SceneChanger.return_from_subscene()
	SceneChanger.reset_stepcount()
	UILayer.visible = true
	pass
