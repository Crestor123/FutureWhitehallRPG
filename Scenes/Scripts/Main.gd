extends Node2D

@onready var UILayer = $UILayer
@onready var UI = $UILayer/OverworldUI
@onready var SceneChanger = $SceneChanger
@onready var Player = $Player

@export var StartingScene : String
@export var StartingPosition : Vector2

func _ready():
	UI.interact.connect(interact)
	UI.buttonPressed.connect(ui_button)
	UI.menuButtonPressed.connect(open_menu)
	
	SceneChanger.setInteractable.connect(interactable_set)
	SceneChanger.unsetInteractable.connect(interactable_unset)
	SceneChanger.load_scene(StartingScene, StartingPosition)
	SceneChanger.encounter.connect(enter_battle)
	
	Player.initialize()

func ui_button(button : String):
	if button == "end_interact":
		end_interact()
	pass

func interact():
	SceneChanger.disable_movement()
	var interactable = SceneChanger.currentInteractable
	interactable.interact()
	for event in interactable.events:
		event.Game = self
		event.UI = UI
		event.Player = Player
			
		event.process_event()
	pass
	
func end_interact():
	SceneChanger.enable_movement()
	UI.clear_dialog()
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

func battle_victory(experience, itemDrops, moneyDrop):
	print("Battle won!")
	print(experience)
	print(moneyDrop)
	print(itemDrops)
	
	Player.Inventory.add_money(moneyDrop)
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
