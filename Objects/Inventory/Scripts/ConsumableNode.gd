extends ItemNode

class_name ConsumableNode

#@export_enum ("health", "mana", "strength", "intelligence", "dexterity",
	#"speed", "vitality", "resistance") var stat : String
@export_enum ("health", "mana") var stat : String

@export_enum ("fire", "electricity", "water", 
	"acid", "air", "void", "earth") var element : String

@export var bonus : int
@export var turns : int
@export var battleOnly : bool = false
@export var targetAllies : bool = true
@export var targetAll : bool = false

@export var additionalEffects : Array[EffectResource]

func initialize():
	super.initialize()
	stat = data.stat
	element = data.element
	bonus = data.bonus
	turns = data.turns
	battleOnly = data.battleOnly
	targetAllies = data.targetAllies
	targetAll = data.targetAll
	additionalEffects = data.additionalEffects
