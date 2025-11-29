extends ItemNode

class_name SpellCardNode

@export var bonuses = {
	"health": 0,
	"mana": 0,
	"strength": 0,
	"intelligence": 0,
	"dexterity": 0,
	"speed": 0,
	"vitality": 0,
	"resistance": 0,
}

@export var resistances = {
	"fire": 0,
	"electricity": 0,
	"water": 0,
	"acid": 0,
	"air": 0,
	"void": 0,
	"earth": 0
}

@export var statusResists = {
	"burn": 0,
	"sleep": 0,
	"silence": 0,
	"slow": 0,
	"stun": 0,
	"blind": 0
}

@export_enum ("fire", "electricity", "water", 
"acid", "air", "void", "earth", "none") var element : String

@export var memoryCost : int

@export var abilities : Array[AbilityResource]

var Owner : PartyMember = null

func get_class_name():
	return "SpellCardNode"

func initialize():
	super.initialize()
	element = data.element
	memoryCost = data.memoryCost
	for stat in bonuses:
		bonuses[stat] = data.bonuses[stat]
	for stat in resistances:
		resistances[stat] = data.resistances[stat]
	for stat in statusResists:
		statusResists[stat] = data.statusResists[stat]
	abilities = data.abilities.duplicate()
