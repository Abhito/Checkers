extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_HSlider_value_changed(value):
	ConfigController.setCameraFOV(value)
	text = str(value)

func _on_ConfigController_ready():
	text = str(ConfigController.getCameraFOV())

