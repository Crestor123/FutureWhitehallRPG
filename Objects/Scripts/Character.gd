extends CharacterBody2D

@onready var Sprite = $Sprite2D
@onready var Collision = $CollisionShape2D
@onready var Raycast = $RayCast2D
@onready var Camera = $Camera2D

@export var speed = 5
@export var tileSize = 16

signal setInteractable
signal unsetInteractable

var interactCollision = false
var moving = false
var active = true

var inputs = {	
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

signal step()

func initialize(newTileSize : int):
	tileSize = newTileSize
	global_position = global_position.snapped(Vector2(tileSize / 2, tileSize))
	#position += Vector2.ONE * tileSize/2
	pass

func setPosition(newPosition : Vector2):
	#new position should be tile coordinates
	if int(newPosition.x) % 2 == 0:
		newPosition.x += 1
	#if int(newPosition.y) % 2 == 0:
		#newPosition.y += 1
	
	global_position = Vector2(newPosition.x * tileSize / 2, newPosition.y * tileSize)
	pass

func setCameraBounds(lowerBounds : Vector2, upperBounds : Vector2):
	Camera.limit_top = lowerBounds.y
	Camera.limit_left = lowerBounds.x
	Camera.limit_right = upperBounds.x
	Camera.limit_bottom = upperBounds.y
	pass

func _process(delta):
	if moving: return
	if !active: return
	if Raycast.is_colliding():
		var collider = Raycast.get_collider()
		if collider is Interactable:
			if collider.active:
				interactCollision = true
				setInteractable.emit(collider)
			else:
				interactCollision = false
				unsetInteractable.emit()
	else:
		if interactCollision:
			interactCollision = false
			unsetInteractable.emit()
	for dir in inputs.keys():
		if Input.is_action_pressed(dir):
			move(dir)

func move(dir):
	if !active: return
	
	Raycast.target_position = inputs[dir] * tileSize
	Raycast.force_raycast_update()
	if !Raycast.is_colliding():
		var tween = create_tween()
		tween.tween_property(self, "position", 
		position + inputs[dir] * tileSize, 
		1.0 / speed)
		
		moving = true
		await tween.finished
		moving = false
		step.emit()
