extends PanelContainer

@onready var Sprite = $MarginContainer/HBoxContainer/Sprite
@onready var lblName = $MarginContainer/HBoxContainer/VBoxContainer/lblName
@onready var lblLevel = $MarginContainer/HBoxContainer/VBoxContainer/lblLevel
@onready var lblExperience = $MarginContainer/HBoxContainer/VBoxContainer2/lblExperience
@onready var lblNext = $MarginContainer/HBoxContainer/VBoxContainer2/lblNext
@onready var XpBar = $MarginContainer/HBoxContainer/VBoxContainer2/XPBar

signal finished

var partyMember : PartyMember
var experience : int
var level : int
var xpCurrent : int
var xpToLevel : int
var xpPrevLevel : int

func initialize(ally: AllyBattler, xp: int):
	experience = xp
	partyMember = ally.partyMember
	
	level = partyMember.level
	xpCurrent = partyMember.experience
	xpToLevel = partyMember.xpToLevel
	xpPrevLevel = partyMember.xpPrevLevel
	
	Sprite = partyMember.sprite
	lblName.text = partyMember.Name
	lblLevel.text = str("Lv: ", level)
	lblExperience.text = str("XP: ", experience)
	lblNext.text = str("Next: ", xpToLevel)
	
	XpBar.animationFinished.connect(check_xpBar)
	
	if partyMember.experience == 0:
		XpBar.set_bar(0)
	else:
		XpBar.set_bar(float(xpCurrent) / (float(xpToLevel)) * 100)
		
func xp_progress():
	if experience == 0 and xpCurrent == 0:
		XpBar.set_bar(0)
		finished.emit(self)
	else:
		var numerator : float = (xpCurrent + experience) - xpPrevLevel
		XpBar.update_bar((numerator / float(xpToLevel)) * 100)

func check_xpBar():
	if (xpCurrent + experience) >= xpToLevel:
		var xpLeft = experience - xpToLevel
		#Show level up animation
		level += 1
		experience = xpLeft
		xpPrevLevel = xpToLevel
		xpToLevel = partyMember.xp_to_next_level(level)
		
		lblLevel.text = str("Lv: ", level)
		lblNext.text = str("Next: ", xpToLevel)
		
		XpBar.set_bar(0)
		xp_progress()
	else:
		finished.emit(self)
	pass

func skip():
	xpCurrent += experience
	while xpCurrent >= xpToLevel:
		level += 1
		xpPrevLevel = xpToLevel
		xpToLevel = partyMember.xp_to_next_level(level)
	lblLevel.text = str("Lv: ", level)
	lblNext.text = str("Next: ", xpToLevel)
	if ((xpCurrent + experience) - xpPrevLevel) == 0:
		XpBar.set_bar(0)
	else:
		var numerator : float = (xpCurrent + experience) - xpPrevLevel
		XpBar.update_bar((numerator / float(xpToLevel)) * 100)
	finished.emit(self)
	pass
