extends Node2D

@onready var Sprite = $Sprite2D

@export var partyMember : PartyMember
var Stats : Node = null
var Abilities : Node = null

func initialize():
	if !partyMember: return
	Stats = partyMember.Stats
	Abilities = partyMember.Abilities
	Sprite.texture = partyMember.sprite
