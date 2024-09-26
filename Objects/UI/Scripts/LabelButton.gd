extends Control

@onready var Icon = $HBoxContainer/Icon
@onready var lblName = $HBoxContainer/Name
@onready var btnSelect = $Select

signal pressed
signal getData

var data : Dictionary
var emittedData : Array[String]

func add_data(key : String, value):
	data[key] = value
	pass

func set_label(setName : String):
	lblName.text = setName

func set_icon(texture : Texture2D):
	Icon.texture = texture

func _on_select_pressed():
	getData.emit(data)
	pressed.emit()
