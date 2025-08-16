class_name AllyBattler extends Battler

@export var partyMember: PartyMember

func initialize():
	Name = partyMember.Name
	Sprite.texture = partyMember.sprite
	icon = partyMember.sprite
	
	Stats.queue_free()
	Stats = partyMember.Stats
	Abilities.queue_free()
	Abilities = partyMember.Abilities
	super.initialize()
	
func start_turn(turnCount: int):
	super.start_turn(turnCount)
	
	Anim.play("Ready")
	Abilities.used_ability.connect(end_turn)

func end_turn(abilityName: String = ""):
	Abilities.used_ability.disconnect(end_turn)
	
	Anim.play("End")
	await animationFinished
	
	endTurn.emit()
	battlerReady.emit(self)
