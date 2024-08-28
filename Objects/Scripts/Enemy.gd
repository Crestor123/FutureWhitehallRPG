extends Node2D

@onready var Sprite = $Sprite2D
@onready var Abilities = $AbilityComponent
@onready var Stats = $StatComponent
@onready var Select = $Sprite2D/Button

@export var data : EnemyResource

var targets : Array[Node]
var allies : Array[Node]

signal on_select

func initialize():
	if !data: return
	
	name = data.name
	for item in data.stats:
		Stats.stats[item] = data.stats[item]
	for item in data.resistances:
		Stats.resistances[item] = data.resistances[item]
	Abilities.initialize(data.abilities)
	Sprite.texture = data.sprite
	pass

#enemies and allies are from the view of this node
#players = enemies, allies = other monsters
func start_turn(turnCount):
	var ability = select_ability(turnCount)
	var targetArray = select_target(ability)
	Abilities.use_ability(ability, targetArray)

func select_ability(turnCount) -> Node:
	return Abilities.get_child(turnCount % Abilities.get_child_count())
	pass

func select_target(ability):
	if ability.target == "multi":
		return targets
		
	var targetIndex = randi_range(0, targets.size() - 1)
	var targetArray : Array[Node] = [targets[targetIndex]]
	return targetArray
	pass

func _on_button_pressed():
	on_select.emit(self)
