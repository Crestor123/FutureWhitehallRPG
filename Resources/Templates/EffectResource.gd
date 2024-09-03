extends Resource

class_name EffectResource

#The stats that the effect modifies
@export var stats = {"health": false, "mana": false, "strength": false, 
	"intelligence": false, "dexterity": false, 
	"speed": false, "vitality": false, "resistance": false}

#minor = 10%, normal = 25%, major = 50%
@export_enum ("custom", "minor", "normal", "major") var value
@export var customValue : int = 0

@export_enum ("burn", "sleep", "death", "silence", "haste", "slow", "stun", 
"shield", "m-shield", "blind", "defend", "regen", "analyze") var status

@export var debuff : bool = false
