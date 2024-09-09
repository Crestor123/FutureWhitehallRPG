extends Node

@export var source : Node
@export var ability : Node
@export var turns : int

@export var statValues = {
	"health": 0,
	"mana": 0,
	"strength": 0,
	"intelligence": 0,
	"dexterity": 0,
	"speed": 0,
	"vitality": 0,
	"resistance": 0
}

@export var type : String

@export_enum ("fire", "electricity", "water", 
	"acid", "air", "void", "earth") var element : String
	
@export var disablingEffects = [
	"stun",
	"death",
	"sleep",
]
@export var disabling : bool = false

var target : Node = null

func initialize(setSource : Node, setAbility : Node, effect : EffectResource):
	source = setSource
	ability = setAbility
	element = ability.element
	turns = ability.turns
	target = get_parent()
	type = effect.status
	
	#Calculate the percentage to modify each stat by
	var percent : int = 0
	if effect.value == 0:
		percent = effect.customValue
	else:
		match effect.value:
			1: percent = 10	#Minor
			2: percent = 25	#Normal
			3: percent = 50	#Major
			4: percent = 100#Max
	
	if effect.debuff: percent *= -1	#The effect will deal damage rather than heal
	
	
	
	for stat in effect.stats:
		if effect.stats[stat]:	#If the stat is checked
			statValues[stat] = target.stats[stat] * (float(percent) / 100)
			
	if effect.status == "revive":
		if target.dead == true: 
			target.revive()
			target.take_damage(-statValues["health"], "none", "none")
			
	for item in statValues:
		if item != "health" and item != "mana":
			target.tempStats[item] += statValues[item]
			
	if effect.status in disablingEffects:
		#The debuff prevents the target from acting
		disabling = true
	
	
func tick():
	if turns == 0: 
		expire()
		return
		
	if statValues["health"] != 0:
		target.take_damage(-statValues["health"], "none", element)
	if statValues["mana"] != 0:
		target.tempStats.mana += statValues["mana"]
	
	turns -= 1
	if turns == 0:
		expire()
	
func expire():
	for item in statValues:
		if item != "health" and item != "mana":
			target.tempStats[item] -= statValues[item]
			
	queue_free()
