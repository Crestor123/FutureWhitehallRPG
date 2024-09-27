extends Control

class_name LabelButton

@onready var Icon = $HBoxContainer/Icon
@onready var lblName = $HBoxContainer/Name
@onready var btnSelect = $Select

@export var defaultTexture : Texture2D

signal pressed
signal getData

var data : Dictionary

func add_data(key : String, value):
	data[key] = value
	pass

func set_label(setName : String):
	lblName.text = setName

func append_label(append : String):
	lblName.text = lblName.text + append

func set_icon(texture : Texture2D):
	Icon.texture = texture

func _on_select_pressed():
	getData.emit(data)
	pressed.emit()
