extends ItemNode

class_name ConsumableNode

@export_enum ("health", "mana", "strength", "intelligence", "dexterity",
	"speed", "vitality", "resistance") var stat : String

@export_enum ("fire", "electricity", "water", 
	"acid", "air", "void", "earth") var element : String

@export var bonus : int
@export var turns : int
