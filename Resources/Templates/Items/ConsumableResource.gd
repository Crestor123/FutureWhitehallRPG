extends ItemResource

class_name ConsumableResource

#@export_enum ("health", "mana", "strength", "intelligence", "dexterity",
	#"speed", "vitality", "resistance") var stat : String
@export_enum ("health", "mana") var stat : String

@export_enum ("fire", "electricity", "water", 
	"acid", "air", "void", "earth") var element : String

@export var bonus : int
@export var turns : int
@export var battleOnly : bool
@export var targetAllies : bool
@export var targetAll : bool

@export var additionalEffects : Array[EffectResource]
