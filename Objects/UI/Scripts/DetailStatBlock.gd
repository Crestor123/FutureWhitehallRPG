extends PanelContainer

@onready var btnClose = $MarginContainer/VBoxContainer/HBoxContainer/btnClose

@onready var Sprite = $MarginContainer/VBoxContainer/HBoxContainer/Sprite
@onready var lblName = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/lblName
@onready var lblLevelVal = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/lblLevelValue

@onready var lblHealthVal = $MarginContainer/VBoxContainer/HBoxContainer2/StatContainer/lblHealthValue
@onready var lblStrengthVal = $MarginContainer/VBoxContainer/HBoxContainer2/StatContainer/lblStrengthValue
@onready var lblIntelligenceVal = $MarginContainer/VBoxContainer/HBoxContainer2/StatContainer/lblIntelligenceValue
@onready var lblDexterityVal = $MarginContainer/VBoxContainer/HBoxContainer2/StatContainer/lblDexterityValue
@onready var lblSpeedVal = $MarginContainer/VBoxContainer/HBoxContainer2/StatContainer/lblSpeedValue
@onready var lblVitalityVal = $MarginContainer/VBoxContainer/HBoxContainer2/StatContainer/lblVitalityValue
@onready var lblResistanceVal = $MarginContainer/VBoxContainer/HBoxContainer2/StatContainer/lblResistanceValue

@onready var lblFire = $MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/lblFire
@onready var lblEarth = $MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/lblEarth
@onready var lblWater = $MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/lblWater
@onready var lblAir = $MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/lblAir
@onready var lblElectricity = $MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/lblElectricity
@onready var lblAcid = $MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/lblAcid
@onready var lblVoid = $MarginContainer/VBoxContainer/HBoxContainer2/GridContainer/lblVoid

signal close

#stats should be a stat component node
func initialize(sprite: Texture2D, battlerName: String, stats: Node):
	Sprite.texture = sprite
	lblName.text = battlerName
	lblLevelVal.text = str(stats.level)
	
	lblHealthVal.text = str(stats.get_health()) + " / " + str(stats.get_stat("health"))
	lblStrengthVal.text = str(stats.get_stat("strength"))
	lblIntelligenceVal.text = str(stats.get_stat("intelligence"))
	lblDexterityVal.text = str(stats.get_stat("dexterity"))
	lblSpeedVal.text = str(stats.get_stat("speed"))
	lblVitalityVal.text = str(stats.get_stat("vitality"))
	lblResistanceVal.text = str(stats.get_stat("resistance"))
	
	lblFire.text = str(stats.get_resistance("fire"))
	lblEarth.text = str(stats.get_resistance("earth"))
	lblWater.text = str(stats.get_resistance("water"))
	lblAir.text = str(stats.get_resistance("air"))
	lblElectricity.text = str(stats.get_resistance("electricity"))
	lblAcid.text = str(stats.get_resistance("acid"))
	lblVoid.text = str(stats.get_resistance("void"))
	pass

func _on_btn_close_pressed():
	close.emit()
