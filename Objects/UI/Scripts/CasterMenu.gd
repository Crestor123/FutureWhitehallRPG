extends Control

@export var LabelButton : PackedScene

@onready var Statblock = $PanelContainer/HBoxContainer/Statblock
@onready var CasterContainer = $PanelContainer/HBoxContainer/CasterSlots
@onready var InventoryContainer = $PanelContainer/HBoxContainer/Inventory

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

	top_menu()
	pass

func top_menu():
	#Create buttons to choose between parts and spells
	clear_inventory()
		
	var partButton = LabelButton.instantiate()
	InventoryContainer.add_child(partButton)
	partButton.set_label("Components")
	partButton.pressed.connect(part_menu)
	
	var spellButton = LabelButton.instantiate()
	InventoryContainer.add_child(spellButton)
	spellButton.set_label("Spell Cards")
	spellButton.pressed.connect(display_spells)
	pass

func part_menu():
	#Create buttons to select between part slots
	clear_inventory()
	clear_caster()
	
	for i in currentPartyMember.Caster.parts:
		var part = LabelButton.instantiate()
		CasterContainer.add_child(part)
		part.set_label(i.capitalize())
		part.add_data("slot", i)
		if currentPartyMember.Caster.parts[i] != null:
			part.set_icon(currentPartyMember.Caster.parts[i].icon)
			part.set_label(currentPartyMember.Caster.parts[i].itemName)
		part.getData.connect(display_parts)
	pass

func display_parts(buttonData):
	#Display all caster parts of a given slot type
	var slot = buttonData["slot"]
	clear_inventory()
	
	for i in Player.Inventory.get_children():
		if i is CasterPartNode:
			if i.slot == slot:
				var part = LabelButton.instantiate()
				InventoryContainer.add_child(part)
				part.set_label(i.itemName)
				part.set_icon(i.icon)
				part.add_data("item", i)
				if slot == "battery":
					part.append_label(" (" + str(i.bonusBattery) + ") ")
				if slot == "memory":
					part.append_label(" (" + str(i.bonusMemory) + ") ")
				if slot == "prism":
					part.append_label(" (" + str(i.bonusMagic) + ") ")
				part.getData.connect(equip_part)
	
func equip_part(buttonData):
	pass

func display_spells():
	#Display all equippable spells
	clear_inventory()
	pass

func equip_spell():
	pass

func clear_inventory():
	for i in InventoryContainer.get_children():
		i.queue_free()

func clear_caster():
	for i in CasterContainer.get_children():
		i.queue_free()

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
