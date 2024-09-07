extends PanelContainer

@onready var lblName = $MarginContainer/HBoxContainer/Name
@onready var icon = $MarginContainer/HBoxContainer/Icon
@onready var lblQuantity = $MarginContainer/HBoxContainer/Quantity

func initialize(itemData : ItemNode):
	lblName.text = itemData.itemName
	icon.texture = itemData.icon
	lblQuantity.text = str(itemData.quantity)
	pass

func _on_button_pressed():
	pass # Replace with function body.
