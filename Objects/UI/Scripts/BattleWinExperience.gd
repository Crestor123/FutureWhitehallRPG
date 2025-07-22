extends GridContainer

@export var levelupCard : PackedScene

var finishedCards : Array[Node]
signal finished

func initialize(partyMembers: Array[Battler], expTotal: int):
	for p in partyMembers:
		var newCard = levelupCard.instantiate()
		add_child(newCard)
		newCard.initialize(p, expTotal)
		newCard.finished.connect(levelup_card_done)
		newCard.xp_progress()
		
func skip():
	for item in get_children():
		item.skip()
	pass

func levelup_card_done(levelupCard: Node):
	finishedCards.append(levelupCard)
	for item in get_children():
		if !finishedCards.has(item):
			return
			
	finished.emit()
	pass
