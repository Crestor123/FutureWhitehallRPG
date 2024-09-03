extends Resource

class_name EffectResource

#The stats that the effect modifies
@export var stats = {"health": false, "mana": false, "strength": false, 
	"intelligence": false, "dexterity": false, 
	"speed": false, "vitality": false, "resistance": false}

#minor = 10%, normal = 25%, major = 50%, max = 100%
@export_enum ("custom", "minor", "normal", "major", "max") var value
@export var customValue : int = 0

@export_enum ("burn", "sleep", "death", "silence", "haste", "slow", "stun", 
"shield", "m-shield", "blind", "defend", "regen", "analyze", "revive") var status : String

@export var debuff : bool = false
