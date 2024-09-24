extends Node

@export var parent : Node

var parts = {
	"battery": null,	#Adds to MP total
	"prism": null,		#Increases magic damage
	"memory": null		#Determines number of spell slots
}

#Holds all currently equipped spells
var spellCards : Array[Node]

var stats = {
	"health": 0,
	"mana": 0,
	"strength": 0,	#Affects physical melee damage
	"intelligence": 0,	#Affects magic damage
	"dexterity": 0,	#Affects ranged damage
	"speed": 0,
	"vitality": 0,	#Affects incoming non-elemental damage
	"resistance": 0,	#Affects incoming elemental damage
}

var resistances = {
	"fire": 0,
	"electricity": 0,
	"water": 0,
	"acid": 0,
	"air": 0,
	"void": 0,
	"earth": 0
}

var statusResist = {
	"burn": 0,
	"sleep": 0,
	"silence": 0,
	"slow": 0,
	"stun": 0,
	"blind": 0
}

func equip_spell(spell : SpellCardNode):
	pass

func unequip_spell(spell : SpellCardNode):
	pass

func equip_part(part : CasterPartNode):
	pass
	
func unequip_part(part : CasterPartNode):
	pass
