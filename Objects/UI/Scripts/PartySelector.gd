extends MarginContainer

@export var SmallPartyCard : PackedScene

@onready var PartyContainer = $PanelContainer/MarginContainer/VBoxContainer/PartyContainer

signal select

func initialize(partyMemberList : Array[PartyMember]):
	for item in partyMemberList:
		var newCard = SmallPartyCard.instantiate()
		PartyContainer.add_child(newCard)
		newCard.button.connect(select_partyMember)
		newCard.initialize(item)
	pass

func select_partyMember(partyMember):
	select.emit(partyMember)
	pass

func _on_back_pressed():
	queue_free()
