extends Node

@export var CharacterObject : PackedScene
@export var BattleScene : PackedScene
@export var PauseMenu : PackedScene

@export var tileSize = 16

var CurrentScene : Node = null
var CurrentPackedScene : PackedScene = null
var PrevScene : PackedScene = null

var Character : Node = null
var CharacterPosition : Vector2 = Vector2.ZERO

var randomEncounters : bool = false
var stepCount : int = 0

var currentInteractable : Interactable = null

signal encounter()
signal setInteractable
signal unsetInteractable

func load_scene(scene : PackedScene, newPosition : Vector2):
	if CurrentScene:
		CharacterPosition = Character.global_position
		PrevScene = CurrentPackedScene
		CurrentScene.queue_free()
		Character.queue_free()
	if !scene:
		CurrentScene = CurrentPackedScene.instantiate()
	else:
		CurrentPackedScene = scene
		CurrentScene = scene.instantiate()
	add_child(CurrentScene)
	
	if CurrentScene is Map:
		stepCount = 24
		create_character()
		Character.setPosition(newPosition)
		
		var formations = get_enemy_formations()
		if formations.size() == 0:
			randomEncounters = false
		else:
			randomEncounters = true
		
		print(CurrentScene.global_position)
		
		link_objects()
	pass

func load_subscene(scene : PackedScene):
	if CurrentScene:
		#Grab battle background from current map
		if scene == BattleScene:
			pass
		
		CharacterPosition = Character.global_position
		PrevScene = CurrentPackedScene
		Character.queue_free()
		CurrentScene.queue_free()
		
	CurrentScene = scene.instantiate()
	add_child(CurrentScene)
	return CurrentScene

func change_subscene(scene : PackedScene):
	#Do not update character position or previous scene
	if CurrentScene:
		CurrentScene.queue_free()
	
	CurrentScene = scene.instantiate()
	add_child(CurrentScene)
	return CurrentScene
	pass

func return_from_subscene():
	if !PrevScene: return
	
	CurrentPackedScene = PrevScene
	CurrentScene.queue_free()
	CurrentScene = CurrentPackedScene.instantiate()
	add_child(CurrentScene)
	
	create_character()
	link_objects()
	Character.global_position = CharacterPosition
	pass

func create_character():
	Character = CharacterObject.instantiate()
	add_child(Character)
	Character.initialize(tileSize)
	Character.step.connect(character_step)
	Character.setInteractable.connect(set_interactable)
	Character.unsetInteractable.connect(unset_interactable)
	Character.setCameraBounds(CurrentScene.CameraLowerBounds, CurrentScene.CameraUpperBounds)

func link_objects():
	for item in CurrentScene.get_children():
		if item is RoomTransition:
			item.roomTransition.connect(load_scene)
		if item is Interactable:
				item.initialize()

func disable_movement():
	if Character:
		Character.active = false

func enable_movement():
	if Character:
		Character.active = true

func reset_stepcount():
	stepCount = 30

func get_enemy_formations():
	if !CurrentScene: return
	if !CurrentScene is Map: return
	
	return CurrentScene.EnemyFormations

func character_step():
	if !randomEncounters:
		return
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

func set_interactable(data):
	currentInteractable = data
	setInteractable.emit()
	pass

func unset_interactable():
	currentInteractable = null
	unsetInteractable.emit()
	pass
