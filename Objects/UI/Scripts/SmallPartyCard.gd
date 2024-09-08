extends Control

@onready var Icon = $PanelContainer/MarginContainer/VBoxContainer/Icon
@onready var Name = $PanelContainer/MarginContainer/VBoxContainer/Name

signal button
var data

func initialize(partyMember : Node):
	data = partyMember
	Icon.texture = partyMember.sprite
	Name.text = partyMember.partyName
	pass

func _on_button_pressed():
	button.emit(data)
