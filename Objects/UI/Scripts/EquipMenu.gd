extends Control

@export var EquipmentSlot : PackedScene

@onready var Icon = $PanelContainer/HBoxContainer/Statblock/Icon
@onready var Health = $PanelContainer/HBoxContainer/Statblock/Health
@onready var Mana = $PanelContainer/HBoxContainer/Statblock/Mana
@onready var EquipmentSlotContainer = $PanelContainer/HBoxContainer/EquipmentSlots
@onready var InventoryContainer = $PanelContainer/HBoxContainer/Inventory

@onready var Strength = $PanelContainer/HBoxContainer/Statblock/Stats/Strength
@onready var Intelligence = $PanelContainer/HBoxContainer/Statblock/Stats/Intelligence
@onready var Dexterity = $PanelContainer/HBoxContainer/Statblock/Stats/Dexterity
@onready var Speed = $PanelContainer/HBoxContainer/Statblock/Stats/Speed
@onready var Vitality = $PanelContainer/HBoxContainer/Statblock/Stats/Vitality
@onready var Resistance = $PanelContainer/HBoxContainer/Statblock/Stats/Resistance

signal back
signal close

var Player : Node
var currentPartyMember : PartyMember
var currentSlot : String

func initialize(setPlayer : Node):
	Player = setPlayer
	currentPartyMember = Player.PartyMembers[0]
	
	Icon = currentPartyMember.sprite
	update_stats()

	for slot in currentPartyMember.Equipment.equipmentSlots:
		var newEquipSlot = EquipmentSlot.instantiate()
		EquipmentSlotContainer.add_child(newEquipSlot)
		newEquipSlot.set_slot(slot)
		newEquipSlot.selectSlot.connect(display_inventory)

func change_partyMember():
	pass

func update_stats():
	Health.text = str(currentPartyMember.Stats.get_health()) + " / " + str(currentPartyMember.Stats.get_stat("health"))
	Mana.text = str(currentPartyMember.Stats.get_mana()) + " / " + str(currentPartyMember.Stats.get_stat("mana"))
	
	Strength.text = "STR: " + str(currentPartyMember.Stats.get_stat("strength"))
	Intelligence.text = "INT: " + str(currentPartyMember.Stats.get_stat("intelligence"))
	Dexterity.text = "DEX: " + str(currentPartyMember.Stats.get_stat("dexterity"))
	Speed.text = "SPD: " + str(currentPartyMember.Stats.get_stat("speed"))
	Vitality.text = "VIT: " + str(currentPartyMember.Stats.get_stat("vitality"))
	Resistance.text = "RES: " + str(currentPartyMember.Stats.get_stat("resistance"))
	pass

func display_inventory(slot : String):
	for i in InventoryContainer.get_children():
		i.queue_free()
	
	currentSlot = slot
	for item in Player.Inventory.get_children():
		if item is EquipNode:
			if item.slot == slot:
				var newEquip = EquipmentSlot.instantiate()
				InventoryContainer.add_child(newEquip)
				newEquip.set_equipment(item, true)
				newEquip.selectData.connect(equip)
				

func equip(item : EquipNode):
	if !currentPartyMember.Equipment.equip(item, currentSlot):
		return
	
	for i in EquipmentSlotContainer.get_children():
		if i.slot == currentSlot:
			i.set_equipment(item)
				
	for i in InventoryContainer.get_children():
			i.set_equipment(i.data, true)
			
	update_stats()
	pass

func _on_back_pressed() -> void:
	back.emit()

func _on_close_pressed() -> void:
	close.emit()
