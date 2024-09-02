extends Node

@export var source : Node
@export var ability : Node
@export var value : int
@export var turns : int

@export_enum ("health", "mana", "strength", "intelligence", "dexterity",
	"speed", "vitality", "resistance") var mainStat : String

@export_enum ("fire", "electricity", "water", 
	"acid", "air", "void", "earth") var element : String

var target : Node = null

func initialize(setSource : Node, setAbility : Node, setValue : int):
	source = setSource
	ability = setAbility
	mainStat = ability.targetStat
	element = ability.element
	value = setValue
	turns = ability.turns
	target = get_parent()
	
	if mainStat != "health" and mainStat != "mana":
		target.tempStats[mainStat] += value
	
func tick():
	if turns == 0: 
		expire()
		return
	
	if mainStat == "health":
		target.takeDamage(-value, element)
	if mainStat == "mana":
		target.tempStats.mana += value
	
	turns -= 1
	if turns == 0:
		expire()
	
func expire():
	if mainStat != "health" and mainStat != "mana":
		target.tempStats[mainStat] -= value
		
	queue_free()
