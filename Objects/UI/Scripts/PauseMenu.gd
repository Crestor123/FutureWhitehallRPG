extends Control

@export var MainMenu : PackedScene
@export var InventoryMenu : PackedScene

func initialize(menuState : String, Player : Node):
	var menu : Node = null
	if menuState == "status":
		menu = MainMenu.instantiate()
	elif menuState == "inventory":
		menu = InventoryMenu.instantiate()
		
	add_child(menu)
	menu.initialize(Player)
	pass
