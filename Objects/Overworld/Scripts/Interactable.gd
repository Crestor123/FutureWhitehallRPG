extends Area2D

class_name Interactable

@onready var Collision = $CollisionShape2D
@onready var Sprite = $Sprite2D

@export var collisionShape : RectangleShape2D
@export var itemData : Array[ItemResource]
@export var spriteData : Texture2D
@export var oneShot : bool
@export var active : bool = true

signal inRange
signal outOfRange

func initialize():
	if collisionShape:
		Collision.shape = collisionShape
	if spriteData:
		Sprite.texture = spriteData

func interact():
	print("interacted")
	if oneShot:
		active = false
		outOfRange.emit()

func _on_body_entered(body):
	if active:
		inRange.emit(self)
	pass 

func _on_body_exited(body):
	outOfRange.emit()
