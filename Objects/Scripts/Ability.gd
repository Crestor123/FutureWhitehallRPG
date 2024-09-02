extends Node

@export var data : AbilityResource

@export var abilityName : String
@export var description : String
@export var icon : Texture2D

@export_enum ("single", "multi", "passive") var target : String

@export_enum ("health", "mana", "strength", "intelligence", 
"dexterity", "speed", "vitality", "resistance") var mainStat : String
@export_enum ("health", "mana", "strength", "intelligence", 
"dexterity", "speed", "vitality", "resistance") var targetStat : String

@export var cost : int = 0
@export var baseDamage : int
@export var multiplier : float
@export var turns : int = 0	#Turns > 0 indicate a buff or debuff

@export_enum ("melee", "ranged", "magical") var type : String
@export_enum ("fire", "electricity", "water", 
"acid", "air", "void", "earth", "none") var element : String

func initialize():
	if !data: return
	
	abilityName = data.name
	description = data.description
	icon = data.icon
	target = data.target
	mainStat = data.mainStat
	targetStat = data.targetStat
	cost = data.cost
	baseDamage = data.baseDamage
	multiplier = data.multiplier
	turns = data.turns
	type = data.type
	element = data.element
	
	print("New ability ", abilityName, " created")
