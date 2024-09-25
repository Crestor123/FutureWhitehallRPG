extends VBoxContainer

@onready var Icon = $Icon
@onready var lblName = $HBoxContainer/Name
@onready var lblLevel = $HBoxContainer/Level
@onready var lblHealth = $Health
@onready var lblMana = $Mana

@onready var lblStrength = $Stats/Strength
@onready var lblIntelligence = $Stats/Intelligence
@onready var lblDexterity = $Stats/Dexterity
@onready var lblSpeed = $Stats/Speed
@onready var lblVitality = $Stats/Vitality
@onready var lblResistance = $Stats/Resistance

@onready var btnBack = $Back
@onready var btnLeft = $SelectorButtons/Left
@onready var btnRight = $SelectorButtons/Right
@onready var btnClose = $Close

func initialize(partyMember : PartyMember):
	Icon.texture = partyMember.sprite
	lblName.text = partyMember.partyName
	lblLevel.text = str(partyMember.level)
	pass

func update_stats(partyMember : PartyMember):
	lblHealth.text = str(partyMember.Stats.get_health()) + " / " + str(partyMember.Stats.get_stat("health"))
	lblMana.text = str(partyMember.Stats.get_mana()) + " / " + str(partyMember.Stats.get_stat("mana"))
	
	lblStrength.text = "STR: " + str(partyMember.Stats.get_stat("strength"))
	lblIntelligence.text = "INT: " + str(partyMember.Stats.get_stat("intelligence"))
	lblDexterity.text = "DEX: " + str(partyMember.Stats.get_stat("dexterity"))
	lblSpeed.text = "SPD: " + str(partyMember.Stats.get_stat("speed"))
	lblVitality.text = "VIT: " + str(partyMember.Stats.get_stat("vitality"))
	lblResistance.text = "RES: " + str(partyMember.Stats.get_stat("resistance"))
