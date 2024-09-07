extends PanelContainer

@export var partyStatblock : PackedScene

@onready var Stats = $HBoxContainer/Stats
@onready var btnItem = $HBoxContainer/Buttons/Items
@onready var btnEquipment = $HBoxContainer/Buttons/Equipment
@onready var btnClose = $HBoxContainer/Buttons/Close

signal close

func initialize(player : Node):
	for item in Stats.get_children():
		item.queue_free()
		
	for item in player.PartyMembers:
		var newStatblock = partyStatblock.instantiate()
		Stats.add_child(newStatblock)
		newStatblock.initialize(item)

func _on_close_pressed():
	close.emit()

func _on_items_pressed():
	pass

func _on_equipment_pressed():
	pass
