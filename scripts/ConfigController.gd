extends Node

onready var cameraFOV

# Called when the node enters the scene tree for the first time.
func _ready():
	#Uncomment following line if you want to reset config or change add more catagories.
	resetConfig()
	var config = ConfigFile.new()
	config.load("res://userconfig.cfg")
	var cameraFOV = config.get_value("Settings", "CameraFOV")
	print(cameraFOV)

#This is a stub where you update all settings from the values provided in the parameters
func updateSettings():
	print("This is a stub where you update all settings from the values provided in the parameters")
	print(cameraFOV)
	var updateconfig = ConfigFile.new()
	updateconfig.load("res://userconfig.cfg")
	updateconfig.set_value("Settings", "CameraFOV", cameraFOV)
	updateconfig.save("res://userconfig.cfg")
	#Alternatively can just change this scruipts properties from another function like Controls in the form of ConfigController.cameraFov = 40

#Run if you want to quickly add new catagories/defaults to the cfg, or reset to default values
func resetConfig():
	var config = ConfigFile.new()
	config.set_value("Settings", "CameraFOV", 90)
	config.save("res://userconfig.cfg")

#Should probably be made a global attribute getter
func getCameraFOV():
	return cameraFOV

#Should probably be made a global attribute setter
func setCameraFOV(value):
	print(value)
	cameraFOV = value
	print(cameraFOV)

	updateSettings()
