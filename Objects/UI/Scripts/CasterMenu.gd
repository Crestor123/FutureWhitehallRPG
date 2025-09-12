extends Control

@export var LabelButton : PackedScene

@onready var Statblock = $PanelContainer/HBoxContainer/Statblock
@onready var CasterContainer = $PanelContainer/HBoxContainer/CasterSlots
@onready var InventoryContainer = $PanelContainer/HBoxContainer/Inventory

var Player : Node

var currentPartyMember : PartyMember
var currentPartyIndex : int = 0

var currentSlot : String

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
	Statblock.update_stats(currentPartyMember)
	
	#If a submenu is selected, preserve it when switching characters

	top_menu()
	pass

func top_menu():
	#Create buttons to choose between parts and spells
	clear_inventory()
	clear_caster()
		
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
	
	var back = LabelButton.instantiate()
	InventoryContainer.add_child(back)
	back.set_label("Back")
	back.pressed.connect(top_menu)
	
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
	currentSlot = slot
	clear_inventory()
	
	var back = LabelButton.instantiate()
	InventoryContainer.add_child(back)
	back.set_label("Back")
	back.pressed.connect(top_menu)
	
	var unequip = LabelButton.instantiate()
	InventoryContainer.add_child(unequip)
	unequip.set_label("Unequip")
	unequip.pressed.connect(unequip_part)
	
	for i in Player.Inventory.get_children():
		if i is CasterPartNode:
			if i.slot == slot and i.Owner == null:
				var part = LabelButton.instantiate()
				InventoryContainer.add_child(part)
				part.set_label(i.itemName)
				part.set_icon(i.icon)
				part.add_data("part", i)
				if slot == "battery":
					part.append_label(" (" + str(i.bonusBattery) + ") ")
				if slot == "memory":
					part.append_label(" (" + str(i.bonusMemory) + ") ")
				if slot == "prism":
					part.append_label(" (" + str(i.bonusMagic) + ") ")
				if i.Owner == currentPartyMember:
					part.append_label(" (E)")
				part.getData.connect(equip_part)
	
func equip_part(buttonData):
	var part = buttonData["part"]
	
	currentPartyMember.Caster.equip_part(part)
	
	for i in CasterContainer.get_children():
		if i.data["slot"] == currentSlot:
			i.set_icon(part.icon)
			i.set_label(part.itemName)
			i.add_data("part", part)
			if currentSlot == "battery":
				i.append_label(" (" + str(part.bonusBattery) + ") ")
			elif currentSlot == "memory":
				i.append_label(" (" + str(part.bonusMemory) + ") ")
			elif currentSlot == "prism":
				i.append_label(" (" + str(part.bonusMagic) + ") ")
			break
	
	for i in InventoryContainer.get_children():
		if !i.data.has("part"): continue
		i.set_label(i.data["part"].itemName)
		var slot = i.data["part"].slot
		if slot == "battery":
			i.append_label(" (" + str(i.data["part"].bonusBattery) + ") ")
		elif slot == "memory":
			i.append_label(" (" + str(i.data["part"].bonusMemory) + ") ")
		elif slot == "prism":
			i.append_label(" (" + str(i.data["part"].bonusMagic) + ") ")
		if i.data["part"].Owner == currentPartyMember:
			i.append_label(" (E)")
			
	Statblock.update_stats(currentPartyMember)
	pass

func unequip_part():
	var part : CasterPartNode = null
	var slot = null
	for i in CasterContainer.get_children():
		if i.data["slot"] == currentSlot:
			slot = i
			part = i.data["part"]
			break
	
	currentPartyMember.Caster.unequip_part(part)
	slot.set_label(currentSlot.capitalize())
	slot.data["part"] = null
	Statblock.update_stats(currentPartyMember)
	pass

func display_spells():
	#Display all equippable spells
	clear_inventory()
	clear_caster()
	
	var back = LabelButton.instantiate()
	InventoryContainer.add_child(back)
	back.set_label("Back")
	back.pressed.connect(top_menu)
	
	for i in currentPartyMember.Caster.spellCards:
		var spell = LabelButton.instantiate()
		CasterContainer.add_child(spell)
		spell.set_label(i.itemName + " " + str(i.memoryCost))
		spell.set_icon(i.icon)
		spell.add_data("spell", i)
		spell.getData.connect(unequip_spell)
	
	for i in Player.Inventory.get_children():
		if i is SpellCardNode and i.Owner == null:
			var spell = LabelButton.instantiate()
			InventoryContainer.add_child(spell)
			spell.set_label(i.itemName + " " + str(i.memoryCost))
			spell.set_icon(i.icon)
			spell.add_data("spell", i)
			if i.Owner == currentPartyMember:
				spell.append_label(" (E)")
				spell.getData.connect(unequip_spell)
			else:
				spell.getData.connect(equip_spell)
	pass

func equip_spell(buttonData):
	var spell = buttonData["spell"]
	currentPartyMember.Caster.equip_spell(spell)
	
	#Add a new button to the caster for the equipped spell
	var newLabel = LabelButton.instantiate()
	CasterContainer.add_child(newLabel)
	newLabel.set_label(spell.itemName + " " + str(spell.memoryCost))
	newLabel.set_icon(spell.icon)
	newLabel.add_data("spell", spell)
	newLabel.getData.connect(unequip_spell)
	
	#Update the inventory list
	for i in InventoryContainer.get_children():
		if !i.data.has("spell"): continue
		i.set_label(i.data["spell"].itemName + " " + str(i.data["spell"].memoryCost))
		if i.getData.is_connected(equip_spell):
			i.getData.disconnect(equip_spell)
		if i.getData.is_connected(unequip_spell):
			i.getData.disconnect(unequip_spell)
		if i.data["spell"].Owner == currentPartyMember:
			i.append_label(" (E)")
			i.getData.connect(unequip_spell)
		else:
			i.getData.connect(equip_spell)
			
	Statblock.update_stats(currentPartyMember)
	pass

func unequip_spell(buttonData):
	var spell = buttonData["spell"]
	currentPartyMember.Caster.unequip_spell(spell)
	
	#Check the caster and delete the selected spell
	for i in CasterContainer.get_children():
		if i.data["spell"] == spell:
			i.queue_free()
			break
			
	#Update the inventory list
	for i in InventoryContainer.get_children():
		if !i.data.has("spell"): continue
		i.set_label(i.data["spell"].itemName + " " + str(i.data["spell"].memoryCost))
		if i.getData.is_connected(equip_spell):
			i.getData.disconnect(equip_spell)
		if i.getData.is_connected(unequip_spell):
			i.getData.disconnect(unequip_spell)
		if i.data["spell"].Owner == currentPartyMember:
			i.append_label(" (E)")
			i.getData.connect(unequip_spell)
		else:
			i.getData.connect(equip_spell)
			
	Statblock.update_stats(currentPartyMember)
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
