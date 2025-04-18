extends PanelContainer

@onready var Sprite = $MarginContainer/HBoxContainer/Sprite
@onready var lblName = $MarginContainer/HBoxContainer/VBoxContainer/lblName
@onready var lblLevel = $MarginContainer/HBoxContainer/VBoxContainer/lblLevel
@onready var lblExperience = $MarginContainer/HBoxContainer/VBoxContainer2/lblExperience
@onready var lblNext = $MarginContainer/HBoxContainer/VBoxContainer2/lblNext
@onready var XpBar = $MarginContainer/HBoxContainer/VBoxContainer2/XPBar

func initialize(ally: AllyBattler):
	var p = ally.partyMember
	Sprite = p.sprite
	lblName.text = p.Name
	lblLevel.text = str("Lv: ", p.level)
	lblExperience.text = str("XP: ", p.experience)
	lblNext.text = str("Next: ", p.xpToLevel)
	
	if p.experience == 0:
		XpBar.set_bar(0)
	else:
		XpBar.set_bar((p.xpToLevel / p.experience) * 100)
	
	pass
