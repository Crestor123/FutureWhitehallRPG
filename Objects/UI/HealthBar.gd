extends TextureProgressBar

func update_bar(newValue):
	var tween = self.create_tween()
	tween.tween_property(self, "value", newValue, 1)
	pass
