extends Area2D

class_name TriggerZone

@onready var Sprite = $Sprite2D
@onready var Collision = $CollisionShape2D

@export var linkedScene : PackedScene

signal zoneEntered

func _on_body_entered(body: Node2D) -> void:
	zoneEntered.emit(self)
