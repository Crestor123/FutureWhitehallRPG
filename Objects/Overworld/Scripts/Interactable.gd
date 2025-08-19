class_name Interactable extends StaticBody2D

@onready var Sprite = $Sprite2D
@onready var Collision = $CollisionShape2D

@export var events : Array[EventResource]
@export var tileWidth : int = 1
@export var tileHeight : int = 1
@export var tileSize : int = 16
@export var spriteData : Texture2D
@export var oneShot : bool
@export var active : bool = true

signal inRange
signal outOfRange

func initialize():
	Collision.shape.size.x = tileWidth * tileSize
	Collision.shape.size.y = tileHeight * tileSize
	if spriteData:
		Sprite.region_enabled = false
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
