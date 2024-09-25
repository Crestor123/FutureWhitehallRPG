extends Control

@export var CasterPartButton : PackedScene

@onready var Statblock = $PanelContainer/HBoxContainer/Statblock

var Player : Node

var currentPartyMember : PartyMember
var currentPartyIndex : int = 0

var currentSlot : String
var currentType : String

signal close
signal back

func initialize(setPlayer : Node):
	Player = setPlayer
	currentPartyMember = Player.PartyMembers[currentPartyIndex]
	
	Statblock.initialize(currentPartyMember)
	
	Statblock.btnLeft.pressed.connect(_on_left_pressed)
	Statblock.btnRight.pressed.connect(_on_right_pressed)
	Statblock.btnBack.pressed.connect(_on_back_presssed)
	Statblock.btnClose.pressed.connect(_on_close_pressed)
	
	#If a submenu is selected, preserve it when switching characters

	pass

func top_menu():
	#Create buttons to choose between parts and spells
	pass

func part_menu():
	#Create buttons to select between part slots
	pass

func display_parts():
	#Display all caster parts of a given slot type
	pass
	
func display_spells():
	#Display all equippable spells
	pass

func _on_left_pressed():
	currentPartyIndex -= 1
	if currentPartyIndex < 0:
		currentPartyIndex = Player.PartyMembers.size() - 1
	initialize(Player)

func _on_right_pressed():
	currentPartyIndex += 1
	if currentPartyIndex >= Player.PartyMembers.size():
		currentPartyIndex = 0
	initialize(Player)

func _on_close_pressed() -> void:
	close.emit()
	
func _on_back_presssed() -> void:
	back.emit()
