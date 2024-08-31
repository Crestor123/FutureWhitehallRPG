extends Node2D

@onready var Sprite = $Sprite2D
@onready var Select = $Sprite2D/Button
@onready var HealthBar = $HealthBar

@export var partyMember : PartyMember
var allyName : String = ""
var Stats : Node = null
var Abilities : Node = null

signal on_select
signal dead

func initialize():
	if !partyMember: return
	allyName = partyMember.partyName
	Stats = partyMember.Stats
	Abilities = partyMember.Abilities
	Sprite.texture = partyMember.sprite
	
	Stats.healthChanged.connect(update_healthbar)
	Stats.healthZero.connect(die)

func update_healthbar():
	HealthBar.update_bar(Stats.get_health(true))
	pass

func _on_button_pressed():
	on_select.emit(self)

func die():
	print(partyMember.partyName, " defeated!")
	dead.emit(self)
	pass
