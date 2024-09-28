extends ItemNode

class_name CasterPartNode

@export_enum("battery", "prism", "memory") var slot : String

@export var bonusBattery : int
@export var bonusMagic : float
@export var bonusMemory : int

var Owner : PartyMember = null

func initialize():
	super.initialize()
	slot = data.slot
	bonusBattery = data.bonusBattery
	bonusMagic = data.bonusMagic
	bonusMemory = data.bonusMemory
	pass
