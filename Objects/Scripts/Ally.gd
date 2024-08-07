extends Node2D

@onready var Sprite = $Sprite2D
@onready var Select = $Sprite2D/Button

@export var partyMember : PartyMember
var Stats : Node = null
var Abilities : Node = null

signal on_select

func initialize():
	if !partyMember: return
	Stats = partyMember.Stats
	Abilities = partyMember.Abilities
	Sprite.texture = partyMember.sprite

func _on_button_pressed():
	on_select.emit(self)
