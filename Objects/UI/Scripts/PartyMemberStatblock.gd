extends MarginContainer

@onready var lblName = $HBoxContainer/HBoxContainer/Tags/Name
@onready var lblClass = $HBoxContainer/HBoxContainer/Values/Class
@onready var lblLevel = $HBoxContainer/HBoxContainer/Values/Level
@onready var lblHealth = $HBoxContainer/HBoxContainer/Values/Health
@onready var lblMana = $HBoxContainer/HBoxContainer/Values/Mana

func initialize(partyMember : Node):
	lblName.text = partyMember.Name
	#lblClass.text = partyMember.
	lblLevel.text = (" (" + str(partyMember.experience) + " / " + str(partyMember.xpToLevel) 
	+ ") " + str(partyMember.level))
	lblHealth.text = str(partyMember.Stats.get_health()) + " / " + str(partyMember.Stats.get_stat("health"))
	lblMana.text = str(partyMember.Stats.get_mana()) + " / " + str(partyMember.Stats.get_stat("mana"))
