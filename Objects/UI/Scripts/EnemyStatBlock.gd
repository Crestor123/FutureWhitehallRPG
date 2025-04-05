extends HBoxContainer

@onready var lblName = $Name

func initialize(enemy):
	lblName.text = enemy.Name + " " + enemy.suffix
