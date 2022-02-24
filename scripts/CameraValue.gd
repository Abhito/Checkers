extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_HSlider_value_changed(value):
	print(value)
	ConfigController.setCameraFOV(int(value))
	text = str(value)

