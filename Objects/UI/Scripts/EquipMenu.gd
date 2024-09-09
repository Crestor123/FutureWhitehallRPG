extends Control

@export var EquipmentSlot : PackedScene

@onready var Icon = $PanelContainer/HBoxContainer/Statblock/Icon
@onready var Health = $PanelContainer/HBoxContainer/Statblock/Health
@onready var Mana = $PanelContainer/HBoxContainer/Statblock/Mana
@onready var EquipmentSlotContainer = $PanelContainer/HBoxContainer/EquipmentSlots

@onready var Strength = $PanelContainer/HBoxContainer/Statblock/Stats/Strength
@onready var Intelligence = $PanelContainer/HBoxContainer/Statblock/Stats/Intelligence
@onready var Dexterity = $PanelContainer/HBoxContainer/Statblock/Stats/Dexterity
@onready var Speed = $PanelContainer/HBoxContainer/Statblock/Stats/Speed
@onready var Vitality = $PanelContainer/HBoxContainer/Statblock/Stats/Vitality
@onready var Resistance = $PanelContainer/HBoxContainer/Statblock/Stats/Resistance

signal back
signal close

var currentPartyMember : PartyMember

func initialize(player : Node):
	currentPartyMember = player.PartyMembers[0]
	
	Icon = currentPartyMember.sprite
	Health.text = str(currentPartyMember.Stats.get_health()) + " / " + str(currentPartyMember.Stats.get_stat("health"))
	Mana.text = str(currentPartyMember.Stats.get_mana()) + " / " + str(currentPartyMember.Stats.get_stat("mana"))
	
	Strength.text = "STR: " + str(currentPartyMember.Stats.get_stat("strength"))
	Intelligence.text = "INT: " + str(currentPartyMember.Stats.get_stat("intelligence"))
	Dexterity.text = "DEX: " + str(currentPartyMember.Stats.get_stat("dexterity"))
	Speed.text = "SPD: " + str(currentPartyMember.Stats.get_stat("speed"))
	Vitality.text = "VIT: " + str(currentPartyMember.Stats.get_stat("vitality"))
	Resistance.text = "RES: " + str(currentPartyMember.Stats.get_stat("resistance"))

	for slot in currentPartyMember.Equipment.equipmentSlots:
		var newEquipSlot = EquipmentSlot.instantiate()
		EquipmentSlotContainer.add_child(newEquipSlot)
		newEquipSlot.initialize(slot, currentPartyMember.Equipment.equipmentSlots[slot])

func _on_back_pressed() -> void:
	back.emit()

func _on_close_pressed() -> void:
	close.emit()
