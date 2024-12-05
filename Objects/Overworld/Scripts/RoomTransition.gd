extends Area2D

class_name RoomTransition

@onready var Collision = $CollisionShape2D

@export var collisionShape : RectangleShape2D
@export var linkedScene : PackedScene
#position should be tile coordinates
@export var newPosition : Vector2

signal roomTransition

func _ready():
	if collisionShape:
		Collision.shape = collisionShape

func _on_body_entered(body):
	roomTransition.emit(linkedScene, newPosition)

func _on_body_exited(body):
	pass # Replace with function body.
