extends Node2D

@onready var UILayer = $UILayer
@onready var UI = $UILayer/OverworldUI
@onready var SceneChanger = $SceneChanger
@onready var Player = $Player

@export var StartingScene : PackedScene

func _ready():
	UI.buttonPressed.connect(ui_button)
	SceneChanger.load_scene(StartingScene)
	SceneChanger.encounter.connect(enter_battle)
	Player.initialize()

func ui_button(button : String):
	if button == "status":
		open_menu()

func enter_battle(enemyFormation):
	print(enemyFormation.enemyList)
	await SceneChanger.load_subscene(SceneChanger.BattleScene)
	UILayer.visible = false
	SceneChanger.CurrentScene.initialize(Player.PartyMembers, enemyFormation)
	SceneChanger.CurrentScene.battleFinished.connect(battle_victory)
	pass

func open_menu():
	await SceneChanger.load_subscene(SceneChanger.PauseMenu)
	UILayer.visible = false
	SceneChanger.CurrentScene.initialize(Player.PartyMembers)
	SceneChanger.CurrentScene.close.connect(close_menu)
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
