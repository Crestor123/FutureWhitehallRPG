extends Area2D

class_name RoomTransition

@onready var Collision = $CollisionShape2D

@export var linkedScene : PackedScene
@export var newPosition : Vector2

signal roomTransition

func _on_body_entered(body):
	roomTransition.emit(linkedScene, newPosition)

func _on_body_exited(body):
	pass # Replace with function body.
