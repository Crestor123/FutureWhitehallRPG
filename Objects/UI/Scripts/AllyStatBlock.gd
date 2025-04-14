extends HBoxContainer

@onready var lblName = $Name
@onready var lblHealth = $CenterContainer/Health
@onready var lblMana = $Mana
@onready var healthBar = $CenterContainer/HealthBar

var ally : Node = null

func initialize(setAlly : Node):
	ally = setAlly
	lblName.text = ally.Name
	lblHealth.text = str(ally.Stats.get_health()) + " / " + str(ally.Stats.get_stat("health"))
	healthBar.set_bar(ally.Stats.get_health(true))
	lblMana.set("theme_override_colors/font_color", Color.BLUE)
	lblMana.text = str(ally.Stats.get_mana())
	pass

func update_health(newHealth : int):
	lblHealth.text = str(ally.Stats.get_health()) + " / " + str(ally.Stats.get_stat("health"))
	healthBar.update_bar(ally.Stats.get_health(true))

func update_mana(newMana : int):
	lblMana.text = str(newMana)
	pass
