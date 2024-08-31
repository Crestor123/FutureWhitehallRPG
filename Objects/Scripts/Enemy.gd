extends Node2D

@onready var Sprite = $Sprite2D
@onready var Abilities = $AbilityComponent
@onready var Stats = $StatComponent
@onready var Select = $Sprite2D/Button
@onready var HealthBar = $HealthBar

@export var data : EnemyResource

var enemyName : String = ""

var targets : Array[Node]
var allies : Array[Node]

signal on_select
signal dead

func initialize():
	if !data: return
	
	enemyName = data.name
	for item in data.stats:
		Stats.stats[item] = data.stats[item]
	Stats.tempStats["health"] = Stats.stats["health"]
	Stats.tempStats["mana"] = Stats.stats["mana"]
	for item in data.resistances:
		Stats.resistances[item] = data.resistances[item]
	Abilities.initialize(data.abilities)
	Sprite.texture = data.sprite
	
	Stats.healthChanged.connect(update_healthbar)
	Stats.healthZero.connect(die)

func start_turn(turnCount):
	var ability = select_ability(turnCount)
	var targetArray = select_target(ability)
	Abilities.use_ability(ability, targetArray)

#Uses turn count to choose an ability (implement some AI later)
func select_ability(turnCount) -> Node:
	return Abilities.get_child(turnCount % Abilities.get_child_count())
	pass

#Chooses a target for the current ability
func select_target(ability):
	if ability.target == "multi":
		return targets
		
	var targetIndex = randi_range(0, targets.size() - 1)
	var targetArray : Array[Node] = [targets[targetIndex]]
	return targetArray
	pass

func update_healthbar():
	HealthBar.update_bar(Stats.get_health(true))
	pass

#Enemy selector button signal
func _on_button_pressed():
	on_select.emit(self)

func die():
	print(name, " defeated!")
	dead.emit(self)
	pass
