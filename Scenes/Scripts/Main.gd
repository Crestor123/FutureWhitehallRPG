extends Node2D

@onready var UILayer = $UILayer
@onready var UI = $UILayer/OverworldUI
@onready var SceneChanger = $SceneChanger
@onready var Player = $Player
@onready var Interact = $InteractComponent

@export var StartingScene : PackedScene
@export var StartingPosition : Vector2

func _ready():
	UI.buttonPressed.connect(ui_button)
	UI.menuButtonPressed.connect(open_menu)
	
	SceneChanger.setInteractable.connect(interactable_set)
	SceneChanger.unsetInteractable.connect(interactable_unset)
	SceneChanger.load_scene(StartingScene, StartingPosition)
	SceneChanger.encounter.connect(enter_battle)
	
	Player.initialize()

func ui_button(button : String):
	if button == "interact":
		interact()
	pass

func interact():
	var interactable = SceneChanger.currentInteractable
	for event in interactable.events:
		event.UI = UI
		event.Player = Player
			
		event.process_event()
		
	#if interactable is ItemContainer:
		#if interactable.itemData.size() > 0:
			#for i in interactable.itemData.size():
				#var item = interactable.itemData[i]
				#var amount = interactable.itemAmounts[i]
				#print("Gained ", str(amount), " ", item.name)
				#var options : Array[String] = ["OK"]
				#UI.create_dialog(null, "You found " + str(amount) + " " + item.name + "!", options)
				#for j in amount:
					#Player.Inventory.add_item(item)
		#if interactable.money > 0:
			#print("Gained ", str(interactable.money), " coins")
			#var options : Array[String] = ["OK"]
			#UI.create_dialog(null, "You found " + str(interactable.money) + "!", options)
			#Player.Inventory.add_money(interactable.money)
	pass
	
func interactable_set():
	UI.show_interact_button()
	pass
	
func interactable_unset():
	UI.hide_interact_button()
	pass

func enter_battle(enemyFormation):
	print(enemyFormation.enemyList)
	await SceneChanger.load_subscene(SceneChanger.BattleScene)
	UILayer.visible = false
	SceneChanger.CurrentScene.initialize(Player.PartyMembers, enemyFormation, Player.Inventory)
	SceneChanger.CurrentScene.battleWon.connect(battle_victory)
	pass

func open_menu(menuState : String):
	await SceneChanger.load_subscene(SceneChanger.PauseMenu)
	SceneChanger.CurrentScene.initialize(menuState, Player)
	SceneChanger.CurrentScene.close.connect(close_menu)
	UILayer.visible = false
	pass

func close_menu():
	SceneChanger.return_from_subscene()
	UILayer.visible = true
	pass

func battle_victory(experience, itemDrops):
	print("Battle won!")
	print(experience)
	print(itemDrops)
	for item in itemDrops:
		Player.Inventory.add_item(item)
	for partyMember in Player.PartyMembers:
		partyMember.add_battle_xp(experience)
	SceneChanger.return_from_subscene()
	SceneChanger.reset_stepcount()
	UILayer.visible = true
	pass

func battle_loss():
	print("Battle Lost...")
	SceneChanger.return_from_subscene()
	SceneChanger.reset_setpcount()
	UILayer.visible = true
	pass
