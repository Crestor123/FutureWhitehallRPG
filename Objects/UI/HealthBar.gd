extends TextureProgressBar

func set_bar(newValue):
	value = newValue

func update_bar(newValue):
	var tween = self.create_tween()
	tween.tween_property(self, "value", newValue, 1)
	pass
