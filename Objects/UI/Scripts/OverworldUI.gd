extends Control

@onready var menuPanel = $PanelContainer

func _ready():
	#Move the menu panel offscreen
	menuPanel.visible = false
	menuPanel.position.x = -(menuPanel.size.x)
	pass

func _on_btn_menu_pressed():
	menuPanel.visible = true
	var T = self.create_tween()
	T.tween_property(menuPanel, "position", Vector2(0, 0), 0.5)
	pass

func _on_btn_status_pressed():
	pass

func _on_btn_items_pressed():
	pass

func _on_btn_equipment_pressed():
	pass

func _on_btn_close_pressed():
	var T = self.create_tween()
	T.tween_property(menuPanel, "position", Vector2(-menuPanel.size.x, 0), 0.5)
	await T.finished
	menuPanel.visible = false
