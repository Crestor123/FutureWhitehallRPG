extends Control

@onready var Icon = $HBoxContainer/Icon
@onready var lblName = $HBoxContainer/Name
@onready var btnSelect = $Select

var slot : String

func set_caster_part(part : CasterPartNode):
	lblName.text = part.name
	Icon.texture = part.icon
	pass
