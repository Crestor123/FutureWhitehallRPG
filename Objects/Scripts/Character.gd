extends CharacterBody2D

@onready var Sprite = $Sprite2D
@onready var Collision = $CollisionShape2D
@onready var Raycast = $RayCast2D
@onready var Camera = $Camera2D

@export var speed = 5
@export var tileSize = 16

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
	position = position.snapped(Vector2(tileSize / 2, tileSize))
	#position += Vector2.ONE * tileSize/2
	pass

func setPosition(newPosition : Vector2):
	#x component must be a multiple of tilesize / 2
	#y component must be a multiple of tilsize
	position = newPosition.snapped(Vector2(tileSize / 2, tileSize))
	pass

func setCameraBounds(lowerBounds : Vector2, upperBounds : Vector2):
	var offsetLowerBounds = Vector2(lowerBounds.x - global_position.x, global_position.y - lowerBounds.y)
	
	Camera.limit_top = offsetLowerBounds.y
	Camera.limit_left = offsetLowerBounds.x
	Camera.limit_right = upperBounds.x
	Camera.limit_bottom = upperBounds.y
	pass

func _process(delta):
	if moving: return
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
