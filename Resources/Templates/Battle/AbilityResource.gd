extends Resource

class_name AbilityResource

@export var name : String
@export var description : String
@export var icon : Texture2D

@export_enum ("single", "multi", "passive", "self") var target : String

@export var targetAllies : bool

@export_enum ("health", "mana", "strength", "intelligence", 
"dexterity", "speed", "vitality", "resistance") var mainStat : String
#@export_enum ("health", "mana", "strength", "intelligence", 
#"dexterity", "speed", "vitality", "resistance") var targetStat : String
@export_enum ("health", "mana") var targetStat : String

@export var manaCost : int = 0
@export var ammoCost : int = 0
#The ability uses all equipped guns, spending ammo from each
@export var allGuns : bool = false

@export var baseDamage : int
@export var multiplier : float
@export var accuracy : float
@export var turns : int = 0

@export_enum ("melee", "ranged", "magical") var type : String
@export_enum ("fire", "electricity", "water", 
"acid", "air", "void", "earth", "none") var element : String

@export var statusEffects : Array[EffectResource]
