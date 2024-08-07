extends CharacterBody2D

@onready var Sprite = $Sprite2D
@onready var Collision = $CollisionShape2D
@onready var Raycast = $RayCast2D

@export var speed = 5
@export var tileSize = 32

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
	position = position.snapped(Vector2.ONE * tileSize)
	position += Vector2.ONE * tileSize/2
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
