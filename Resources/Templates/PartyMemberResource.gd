extends Resource

class_name PartyMemberResource

@export var name : String
@export var title : String

@export var sprite : Texture2D

@export var level : int = 1

@export var stats = {
	"health": 0,
	"mana": 0,
	"strength": 0,	#Affects physical melee damage
	"intelligence": 0,	#Affects magic damage
	"dexterity": 0,	#Affects accuracy
	"speed": 0,
	"vitality": 0,
	"resistance": 0,
}

@export var statGrowths = {
	"health": 5.0,
	"mana": 2.0,
	"strength": 1.2,
	"intelligence": 2.2,
	"dexterity": 1.8,
	"speed": 0.6,
	"vitality": 1.5,
	"resistance": 1.8,
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

@export var statusResist = {
	"burn": 0,
	"sleep": 0,
	"silence": 0,
	"slow": 0,
	"stun": 0,
	"blind": 0
}

@export var abilities : Array[AbilityResource]

@export var inventory : Array[ItemResource]

@export var equipment: Dictionary[String, ItemResource] = {
	"mainhand": null,
	"offhand": null,
	"head": null,
	"body": null,
	"accessory": null,
}

@export var casterComponents: Dictionary[String, ItemResource] = {
	"battery": null,
	"prism": null,
	"memory": null
}

@export var spells: Array[SpellCardResource]
