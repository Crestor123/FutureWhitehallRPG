extends PanelContainer

@onready var Icon = $MarginContainer/HBoxContainer/Icon
@onready var TextContent = $MarginContainer/HBoxContainer/TextContent

@export var icon : Texture2D
@export var text : String

func initialize():
	if icon:
		Icon.texture = icon
	else:
		Icon.visible = false
	if text:
		TextContent.text = text
		TextContent.type_out()

func set_data(setIcon : Texture2D, setText : String):
	icon = setIcon
	text = setText
