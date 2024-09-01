extends Node2D

@onready var UI = $UILayer
@onready var Tilemap = $TileMap
@onready var CurrentScene = $CurrentScene
@onready var Player = $Player

@export var StartingScene : PackedScene

func _ready():
	CurrentScene.load_scene(StartingScene)
	CurrentScene.encounter.connect(enter_battle)
	Player.initialize()

func enter_battle(enemyFormation):
	print(enemyFormation.enemyList)
	await CurrentScene.load_battle()
	CurrentScene.CurrentScene.initialize(Player.PartyMembers, enemyFormation)
	CurrentScene.CurrentScene.battleFinished.connect(battle_victory)
	pass

func battle_victory():
	print("Battle won!")
	CurrentScene.return_from_battle()
	pass
