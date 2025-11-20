extends Area2D

class_name RoomTransition

@onready var Collision = $CollisionShape2D
@onready var T = $Timer

@export var collisionShape : RectangleShape2D
@export var linkedScene : String
#position should be tile coordinates
@export var newPosition : Vector2

var active = false

signal roomTransition

func _ready():
	if collisionShape:
		Collision.shape = collisionShape
	T.start()

func _on_body_entered(body):
	if active:
		roomTransition.emit(linkedScene, newPosition)

func _on_body_exited(body):
	active = true
	pass # Replace with function body.

func _on_timer_timeout():
	if get_overlapping_bodies().size() == 0:
		active = true
