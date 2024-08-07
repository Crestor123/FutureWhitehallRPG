extends Node

@export var CharacterObject : PackedScene
@export var BattleScene : PackedScene

@export var tileSize = 32

var CurrentScene : Node = null
var CurrentPackedScene : PackedScene = null
var PrevScene : PackedScene = null

var Character : Node = null
var CharacterPosition : Vector2 = Vector2.ZERO

var stepCount : int = 0

signal encounter()

func load_scene(scene : PackedScene):
	if CurrentScene:
		CharacterPosition = Character.globalPosition
		PrevScene = CurrentPackedScene
		CurrentScene.queue_free()
		
	CurrentPackedScene = scene
	CurrentScene = scene.instantiate()
	add_child(CurrentScene)
	
	if CurrentScene is Map:
		stepCount = 8
		Character = CharacterObject.instantiate()
		add_child(Character)
		Character.initialize(tileSize)
		Character.step.connect(character_step)
	pass

func load_battle():
	if CurrentScene:
		#Grab battle background from current map
		CharacterPosition = Character.global_position
		PrevScene = CurrentPackedScene
		Character.queue_free()
		CurrentScene.queue_free()
		
	CurrentScene = BattleScene.instantiate()
	add_child(CurrentScene)
	
	pass

func return_from_battle():
	if !PrevScene: return
	
	CurrentPackedScene = PrevScene
	CurrentScene.queue_free()
	CurrentScene = CurrentPackedScene.instantiate()
	add_child(CurrentScene)
	
	stepCount = 10
	Character = CharacterObject.instantiate()
	add_child(Character)
	Character.initialize(tileSize)
	Character.global_position = CharacterPosition
	Character.step.connect(character_step)
	pass

func get_enemy_formations():
	if !CurrentScene: return
	if !CurrentScene is Map: return
	
	return CurrentScene.EnemyFormations

func character_step():
	stepCount -= 1
	#print(stepCount)
	if stepCount <= 0:
		#Roll for a random encounter
		if roll_encounter():
			Character.active = false
			encounter.emit(select_formation())

func roll_encounter() -> bool:
	var rand = randi_range(1 + (stepCount * 2), 100)
	if rand < CurrentScene.EncounterChance:
		return true
	else: return false

func select_formation() -> EnemyFormation:
	var formations = get_enemy_formations()
	var rand = randi_range(0, formations.size() - 1)
	return formations[rand]
	pass
