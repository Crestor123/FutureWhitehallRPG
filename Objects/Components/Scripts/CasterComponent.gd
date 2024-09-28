extends Node

@export var parent : Node

var parts = {
	"battery": null,	#Adds to MP total
	"prism": null,		#Increases magic damage
	"memory": null		#Determines memory value, governing amount of spells that can be equipped
}

var maxMemory : int = 0
var usedMemory : int = 0

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
	if spell.Owner != parent: return
	
	spell.Owner = null
	spellCards.erase(spell)
	
	update_stats()
	pass

func unequip_spell(spell : SpellCardNode):
	if spell.Owner != parent: return
	
	spell.Owner = parent
	spellCards.append(spell)
	
	update_stats()
	pass

func update_stats():
	for i in spellCards:
		for j in i.bonuses:
			stats[j] += i.bonuses[j]
		for j in i.resistances:
			resistances[j] += i.bonuses[j]
		for j in i.statusResists:
			statusResist[j] += i.statusResists[j]
	pass

func equip_part(part : CasterPartNode) -> bool:
	#If the part is already equipped, can't equip it again
	if part.Owner != null: return false
	
	#There is already a part equipped to the slot, unequip it
	if parts[part.slot] != null:
		unequip_part(parts[part.slot])
	
	parts[part.slot] = part
	part.Owner = parent
	
	return true
	pass
	
func unequip_part(part : CasterPartNode):
	for i in parts:
		if parts[i] == part:
			parts[i].Owner = null
			parts[i] = null
	pass
