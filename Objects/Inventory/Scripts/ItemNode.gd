extends Node

class_name ItemNode

@export var data : ItemResource

@export var itemName : String
@export var id : String
@export_multiline var description : String
@export var icon : Texture2D

@export var cost : int

@export var stackable : bool
@export var quantity : int = 1

func get_class_name():
	return "ItemNode"

func initialize():
	itemName = data.name
	id = data.id
	description = data.description
	icon = data.icon
	cost = data.cost
	stackable = data.stackable
	pass
