extends PanelContainer

@onready var lblName = $MarginContainer/HBoxContainer/Name
@onready var icon = $MarginContainer/HBoxContainer/Icon
@onready var lblQuantity = $MarginContainer/HBoxContainer/Quantity

var data : ItemNode = null
signal select

func initialize(itemData : ItemNode):
	data = itemData
	lblName.text = data.itemName
	icon.texture = data.icon
	lblQuantity.text = str(data.quantity)
	pass

func _on_button_pressed():
	select.emit(data)
