extends Node

@export var partyMemberScene : PackedScene

@onready var Inventory = $InventoryComponent

var PartyMembers : Array[PartyMember]

func initialize():
	#Takes a list of party member resources
	#Creates a party member node for each given resource
	for item in get_children():
		if item is PartyMember:
			PartyMembers.append(item)
			item.initialize()
			Inventory.initialize(item.data.inventory)
	pass
