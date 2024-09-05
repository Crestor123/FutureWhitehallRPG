extends Area2D

class_name TriggerZone

@onready var Sprite = $Sprite2D
@onready var Collision = $CollisionShape2D

@export_enum ("encounter", "interact", "door") var type : String

@export var linkedScene : PackedScene
@export var newPosition : Vector2

@export var data : Resource

signal zoneEntered

func _on_body_entered(body: Node2D) -> void:
	zoneEntered.emit(self)
