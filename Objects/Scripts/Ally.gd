extends Node2D

@onready var Sprite = $Sprite2D
@onready var Select = $Sprite2D/Button
@onready var HealthBar = $HealthBar

@export var partyMember : PartyMember
var allyName : String = ""
var Stats : Node = null
var Abilities : Node = null
var icon : Texture2D = null

signal on_select
signal endTurn
signal dead
signal revived

func initialize():
	if !partyMember: return
	allyName = partyMember.partyName
	Stats = partyMember.Stats
	Abilities = partyMember.Abilities
	Sprite.texture = partyMember.sprite
	icon = partyMember.sprite
	
	Stats.reviveSignal.connect(revive)
	Stats.healthChanged.connect(update_healthbar)
	Stats.healthZero.connect(die)

func start_turn():
	Stats.tick_buffs()
	for item in Stats.get_children():
		if item.disabling == true:
			#The battler is prevented from acting
			return
	Abilities.used_ability.connect(end_turn)
	pass

func end_turn(abilityName):
	Abilities.used_ability.disconnect(end_turn)
	endTurn.emit()
	pass

func update_healthbar():
	HealthBar.update_bar(Stats.get_health(true))
	pass

func _on_button_pressed():
	on_select.emit(self)

func revive():
	print(partyMember.partyName, " revived!")
	Stats.dead = false
	revived.emit(self)

func die():
	print(partyMember.partyName, " defeated!")
	Stats.dead = true
	dead.emit(self)
	pass
