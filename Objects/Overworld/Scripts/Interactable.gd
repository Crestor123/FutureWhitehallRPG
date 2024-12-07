class_name Interactable extends Area2D

@onready var Area = $CollisionShape2D
@onready var Sprite = $Sprite2D
@onready var Body = $StaticBody2D
@onready var BodyCollision = $StaticBody2D/CollisionShape2D

@export var events : Array[EventResource]
@export var collisionArea : RectangleShape2D
@export var collisionBody : RectangleShape2D
@export var spriteData : Texture2D
@export var oneShot : bool
@export var active : bool = true

signal inRange
signal outOfRange

func initialize():
	if collisionArea:
		Area.shape = collisionArea
	if collisionBody:
		BodyCollision.shape = collisionBody
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
