extends Resource

class_name ItemResource

@export var name : String
@export_multiline var description : String
@export var icon : Texture2D

@export var cost : int
@export var stackable : bool
@export var quantity : int = 1	#Unused for non-stackable items
