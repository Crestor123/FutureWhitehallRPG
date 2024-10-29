extends Control

@export var LabelButton : PackedScene

@onready var EquipmentSlotContainer = $PanelContainer/HBoxContainer/EquipmentSlots
@onready var InventoryContainer = $PanelContainer/HBoxContainer/Inventory
@onready var Statblock = $PanelContainer/HBoxContainer/Statblock

signal back
signal close

var Player : Node

var currentPartyMember : PartyMember
var currentPartyIndex : int = 0

var currentSlot : String
var currentType : String

func initialize(setPlayer : Node):
	Player = setPlayer
	currentPartyMember = Player.PartyMembers[currentPartyIndex]
	
	#Set up the statblock and all of its buttons
	Statblock.initialize(currentPartyMember)
	Statblock.btnLeft.pressed.connect(_on_left_pressed)
	Statblock.btnRight.pressed.connect(_on_right_pressed)
	Statblock.btnBack.pressed.connect(_on_back_pressed)
	Statblock.btnClose.pressed.connect(_on_close_pressed)
	update_stats()

	#Empty out the containers
	for i in EquipmentSlotContainer.get_children():
		i.queue_free()
	for i in InventoryContainer.get_children():
		i.queue_free()

	#Populate the equipment slot list
	var equipmentSlots = currentPartyMember.Equipment.equipmentSlots
	for slot in equipmentSlots:
		var newEquipSlot = LabelButton.instantiate()
		EquipmentSlotContainer.add_child(newEquipSlot)
		
		if equipmentSlots[slot]["equip"] == null:
			#If there isn't anything equipped, show a blank slot
			set_slot(newEquipSlot, slot, equipmentSlots[slot]["type"])
		else:
			#Otherwise, show the equipped item
			set_equipment(newEquipSlot, equipmentSlots[slot]["equip"], false)

		newEquipSlot.getData.connect(display_inventory)

func update_stats():
	Statblock.update_stats(currentPartyMember)

func display_inventory(buttonData):
	#Display the list of equippable items for a given slot
	var slot = buttonData["slot"]
	var type = buttonData["type"]
	
	for i in InventoryContainer.get_children():
		i.queue_free()
	
	#Set up the unequip button
	var btnUnequip = LabelButton.instantiate()
	InventoryContainer.add_child(btnUnequip)
	btnUnequip.set_label("Unequip")
	btnUnequip.add_data("slot", "unequip")
	btnUnequip.pressed.connect(unequip)
	
	currentSlot = slot
	currentType = type
	#Show all items in the inventory of the proper slot
	for item in Player.Inventory.get_children():
		if item is EquipNode:
			if item.slot == type:
				var newEquip = LabelButton.instantiate()
				InventoryContainer.add_child(newEquip)
				set_equipment(newEquip, item, true)
				newEquip.getData.connect(equip)

func equip(buttonData):
	var item = buttonData["item"]
	
	#If the equip fails, break out
	if !currentPartyMember.Equipment.equip(item, currentSlot):
		return
	
	#Update the equipment slot list to show the newly equipped item
	#If an item was unequipped from another slot, this will update here as well
	var i = 0
	var equipmentSlots = currentPartyMember.Equipment.equipmentSlots
	for j in equipmentSlots:
		if equipmentSlots[j]["equip"] == null:
			set_slot(EquipmentSlotContainer.get_child(i), j, equipmentSlots[j]["type"])
		else:
			set_equipment(EquipmentSlotContainer.get_child(i), equipmentSlots[j]["equip"])
		i += 1
	
	#Update the inventory list
	for j in InventoryContainer.get_children():
		if j.data["slot"] != "unequip":
			set_equipment(j, j.data["item"], true)
			if j.data["item"].Owner == currentPartyMember:
				#The same item can't be equipped multiple times
				j.getData.disconnect(equip)
			else:
				j.getData.connect(equip)
			
	update_stats()
	pass

func unequip():
	if !currentSlot: return
	
	var equipment
	
	#Find the item to be unequipped
	var j = 0
	var equipmentSlots = currentPartyMember.Equipment.equipmentSlots
	for i in equipmentSlots:
		if i == currentSlot:
			if equipmentSlots[i]["equip"] != null:
				#This is only set if there is an item equipped to the given slot
				equipment = equipmentSlots[i]["equip"]
				break
		j += 1
	
	#Break out if there is nothing to unequip, or if it fails
	if !equipment: return
	if !currentPartyMember.Equipment.unequip(equipment): return
	
	set_slot(EquipmentSlotContainer.get_child(j), currentSlot, currentType)
	
	for i in InventoryContainer.get_children():
		if i.data["slot"] != "unequip":
			set_equipment(i, i.data["item"], true)
			if i.data["item"].Owner != currentPartyMember:
				i.getData.connect(equip)

	update_stats()

#Button helper functions
func set_slot(button : Node, slot : String, type : String):
	button.set_icon(button.defaultTexture)
	button.set_label(slot.capitalize())
	button.add_data("slot", slot)
	button.add_data("type", type)
	pass
	
func set_equipment(button : Node, equipment : EquipNode, showOwner : bool = false):
	button.set_icon(equipment.icon)
	button.add_data("item", equipment)
	button.add_data("slot", equipment.slot)
	
	if showOwner:
		if equipment.Owner == currentPartyMember:
			button.set_label(equipment.itemName + " (E)")
		else:
			button.set_label(equipment.itemName)
	else:
		button.set_label(equipment.itemName)
	pass

func _on_back_pressed() -> void:
	back.emit()

func _on_close_pressed() -> void:
	close.emit()

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
