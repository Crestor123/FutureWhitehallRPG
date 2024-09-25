extends Control

@export var EquipmentSlot : PackedScene

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
		var newEquipSlot = EquipmentSlot.instantiate()
		EquipmentSlotContainer.add_child(newEquipSlot)
		if equipmentSlots[slot]["equip"] == null:
			newEquipSlot.set_slot(slot, equipmentSlots[slot]["type"])
		else:
			newEquipSlot.set_slot(slot, equipmentSlots[slot]["type"])
			newEquipSlot.set_equipment(equipmentSlots[slot]["equip"])
		newEquipSlot.selectSlot.connect(display_inventory)

func update_stats():
	Statblock.update_stats(currentPartyMember)

func display_inventory(slot : String, type : String):
	for i in InventoryContainer.get_children():
		i.queue_free()
	
	var btnUnequip = EquipmentSlot.instantiate()
	InventoryContainer.add_child(btnUnequip)
	btnUnequip.set_unequip()
	btnUnequip.selectSlot.connect(unequip)
	
	currentSlot = slot
	currentType = type
	for item in Player.Inventory.get_children():
		if item is EquipNode:
			if item.slot == type:
				var newEquip = EquipmentSlot.instantiate()
				InventoryContainer.add_child(newEquip)
				newEquip.set_equipment(item, true)
				if !item.Owner == currentPartyMember:
					newEquip.selectData.connect(equip)
				

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
