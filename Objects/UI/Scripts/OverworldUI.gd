extends Control

@onready var DialogContainer = $DialogContainer
@onready var OptionContainer = $OptionContainer/VBoxContainer
@onready var menuPanel = $PanelContainer
@onready var interactButton = $MarginContainer/Interact
@onready var DialogueState = $DialogueState

@export var button : PackedScene
@export var dialogBox : PackedScene

signal buttonPressed(which)
signal interact()
signal menuButtonPressed(which)

func _ready():
	#Move the menu panel offscreen
	menuPanel.visible = false
	menuPanel.position.x = -(menuPanel.size.x)
	
	DialogueManager.dialogue_ended.connect(clear_dialog)
	
	interactButton.visible = false
	pass

#func create_dialog(icon : Texture2D, text : String, options : Dictionary):
	#Options : Dictionary {label : String, function : Callable}
	#The option button will be tied to the given callable
	#var newDialog = dialogBox.instantiate()
	#DialogContainer.add_child(newDialog)
	#newDialog.set_data(icon, text)
	#newDialog.initialize()
	#
	#for option in options.keys():
		#var newButton = button.instantiate()
		#OptionContainer.add_child(newButton)
		#newButton.set_label(option)
		#newButton.set_icon(null)
		#newButton.pressed.connect(options[option])
		#
	#DialogContainer.show()
	#OptionContainer.show()
	#pass
	
func create_dialogue(dialogue_resource : Resource):
	hide_interact_button()
	DialogueManager.show_dialogue_balloon(dialogue_resource, "", [DialogueState])
	pass

func clear_dialog():
	#DialogContainer.hide()
	#for child in DialogContainer.get_children():
		#child.queue_free()
	#
	#OptionContainer.hide()
	#for child in OptionContainer.get_children():
		#child.queue_free()
		
	DialogueState.reset_data()

func show_interact_button():
	interactButton.show()
	pass
	
func hide_interact_button():
	interactButton.hide()
	pass

func _on_btn_menu_pressed():
	menuPanel.visible = true
	var T = self.create_tween()
	T.tween_property(menuPanel, "position", Vector2(0, 0), 0.5)
	pass

func _on_btn_status_pressed():
	menuButtonPressed.emit("status")
	pass

func _on_btn_items_pressed():
	menuButtonPressed.emit("inventory")
	pass

func _on_btn_equipment_pressed():
	menuButtonPressed.emit("equipment")
	pass

func _on_btn_caster_pressed():
	menuButtonPressed.emit("caster")
	pass

func _on_btn_close_pressed():
	var T = self.create_tween()
	T.tween_property(menuPanel, "position", Vector2(-menuPanel.size.x, 0), 0.5)
	await T.finished
	menuPanel.visible = false

func _on_interact_pressed():
	interact.emit()
	
func _on_option_button_pressed(data : Dictionary):
	buttonPressed.emit(data.option)
