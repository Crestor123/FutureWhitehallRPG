extends Control

@export var MainMenu : PackedScene
@export var InventoryMenu : PackedScene
@export var EquipmentMenu : PackedScene
@export var CasterMenu : PackedScene

signal close

var Player : Node = null

func initialize(menuState : String = "", setPlayer : Node = null):
	for child in get_children():
		child.queue_free()
	
	if setPlayer:
		Player = setPlayer
	var menu : Node = null
	if menuState == "status":
		menu = MainMenu.instantiate()
	elif menuState == "inventory":
		menu = InventoryMenu.instantiate()
	elif menuState == "equipment":
		menu = EquipmentMenu.instantiate()
	elif menuState == "caster":
		menu = CasterMenu.instantiate()
	else:
		menu = MainMenu.instantiate()
		
	add_child(menu)
	menu.initialize(Player)
	menu.close.connect(close_menu)
	
	if menu.has_signal("changeMenu"):
		menu.changeMenu.connect(initialize)
	if menu.has_signal("back"):
		menu.back.connect(initialize)
	pass

func close_menu():
	close.emit()
	pass
	
