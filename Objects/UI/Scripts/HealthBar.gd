extends TextureProgressBar

signal animationFinished

func set_bar(newValue):
	value = newValue

func update_bar(newValue):
	var tween = self.create_tween()
	tween.tween_property(self, "value", newValue, 1)
	tween.tween_callback(animation_finished)
	pass

func animation_finished():
	animationFinished.emit()
