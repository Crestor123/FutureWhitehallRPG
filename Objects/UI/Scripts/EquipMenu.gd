extends Control

@export var EquipmentSlot : PackedScene
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
	
	Statblock.initialize(currentPartyMember)
	Statblock.btnLeft.pressed.connect(_on_left_pressed)
	Statblock.btnRight.pressed.connect(_on_right_pressed)
	Statblock.btnBack.pressed.connect(_on_back_pressed)
	Statblock.btnClose.pressed.connect(_on_close_pressed)
	update_stats()

	for i in EquipmentSlotContainer.get_children():
		i.queue_free()
	for i in InventoryContainer.get_children():
		i.queue_free()

	var equipmentSlots = currentPartyMember.Equipment.equipmentSlots
	for slot in equipmentSlots:
		var newEquipSlot = LabelButton.instantiate()
		EquipmentSlotContainer.add_child(newEquipSlot)
		
		newEquipSlot.add_data("slot", slot)
		newEquipSlot.add_data("type", equipmentSlots[slot]["type"])
		if equipmentSlots[slot]["equip"] == null:
			newEquipSlot.set_label(slot.capitalize())
		else:
			newEquipSlot.add_data("equip", equipmentSlots[slot]["equip"])
			newEquipSlot.set_label(equipmentSlots[slot]["equip"].name)
		
		newEquipSlot.getData.connect(display_inventory)

func update_stats():
	Statblock.update_stats(currentPartyMember)

func display_inventory(buttonData):
	var slot = buttonData["slot"]
	var type = buttonData["type"]
	
	for i in InventoryContainer.get_children():
		i.queue_free()
	
	var btnUnequip = LabelButton.instantiate()
	InventoryContainer.add_child(btnUnequip)
	btnUnequip.set_label("Unequip")
	btnUnequip.pressed.connect(unequip)
	
	currentSlot = slot
	currentType = type
	for item in Player.Inventory.get_children():
		if item is EquipNode:
			if item.slot == type:
				var newEquip = LabelButton.instantiate()
				InventoryContainer.add_child(newEquip)
				newEquip.add_data("item", item)
				newEquip.set_icon(item.icon)
				
				#Show the equipped status of the item
				if !item.Owner:
					newEquip.set_label(item.name)
				else:
					newEquip.set_label(item.name + " (E)")
				if !item.Owner == currentPartyMember:
					newEquip.getData.connect(equip)
				

func equip(item : EquipNode):
	if !currentPartyMember.Equipment.equip(item, currentSlot):
		return
	
	var i = 0
	var equipmentSlots = currentPartyMember.Equipment.equipmentSlots
	for j in equipmentSlots:
		if equipmentSlots[j]["equip"] == null:
			EquipmentSlotContainer.get_child(i).set_slot(j, equipmentSlots[j]["type"])
		else:
			EquipmentSlotContainer.get_child(i).set_equipment(equipmentSlots[j]["equip"])
		i += 1
	
	for j in EquipmentSlotContainer.get_children():
		if j.slot == currentSlot:
			j.set_equipment(item)
				
	for j in InventoryContainer.get_children():
		if j.slot != "unequip":
			j.set_equipment(j.data, true)
			if j.data.Owner == currentPartyMember:
				j.selectData.disconnect(equip)
			else:
				j.selectData.connect(equip)
			
	update_stats()
	pass

func unequip():
	if !currentSlot: return
	
	var equipment
	
	var j = 0
	var equipmentSlots = currentPartyMember.Equipment.equipmentSlots
	for i in equipmentSlots:
		if i == currentSlot:
			if equipmentSlots[i]["equip"] != null:
				equipment = equipmentSlots[i]["equip"]
				break
		j += 1
	
	if !equipment: return
	if !currentPartyMember.Equipment.unequip(equipment): return
	
	EquipmentSlotContainer.get_child(j).set_slot(currentSlot, currentType)
	
	for i in InventoryContainer.get_children():
		if i.slot != "unequip":
			i.set_equipment(i.data, true)
			if i.data.Owner != currentPartyMember:
				i.selectData.connect(equip)

	update_stats()

func set_slot(button : Node, slot : String, type : String):
	button.set_label(slot.capitalize())
	button.add_data("slot", slot)
	button.add_data("type", type)
	pass
	
func set_equipment(button : Node, equipment : EquipNode, showOwner : bool = false):
	button.set_icon(equipment.icon)
	button.add_data("item", equipment)
	button.add_data("equip", equipment.slot)
	
	if showOwner:
		button.set_label(equipment.itemName + " (E)")
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
