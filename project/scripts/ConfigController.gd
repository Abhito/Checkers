extends Node

# Variables
onready var cameraFOV
onready var local_player_one_name setget setLocalPlayerOneName, getLocalPlayerOneName
onready var local_player_two_name setget setLocalPlayerTwoName, getLocalPlayerTwoName
onready var game_mode setget setGameMode, getGameMode
onready var display_mode setget setDisplayMode, getDisplayMode
onready var music_selection setget setMusic, getMusic

# Called when the node enters the scene tree for the first time.
func _ready():
	#Uncomment following line if you want to reset config or change add more catagories.
	resetConfig()
	var config = ConfigFile.new()
	config.load("res://userconfig.cfg")
	cameraFOV = config.get_value("Settings", "CameraFOV")
	local_player_one_name = config.get_value("Settings", "local_player_one_name")
	local_player_two_name = config.get_value("Settings", "local_player_two_name")
	game_mode = config.get_value("Settings", "game_mode")
	display_mode = config.get_value("Settings", "display_mode")
	music_selection = config.get_value("Settings", "music_selection")
	print(local_player_one_name)
	print(local_player_two_name)
	#print(cameraFOV)

#This is a stub where you update all settings from the values provided in the parameters
func updateSettings():
	# print("This is a stub where you update all settings from the values provided in the parameters")
	# print(cameraFOV)
	var updateconfig = ConfigFile.new()
	updateconfig.load("res://userconfig.cfg")
	updateconfig.set_value("Settings", "CameraFOV", cameraFOV)
	updateconfig.set_value("Settings", "local_player_one_name", local_player_one_name)
	updateconfig.set_value("Settings", "local_player_two_name", local_player_two_name)
	updateconfig.set_value("Settings", "game_mode", game_mode)
	updateconfig.set_value("Settings", "display_mode", display_mode)
	updateconfig.set_value("Settings", "music_selection", music_selection)
	updateconfig.save("res://userconfig.cfg")
	print(music_selection)
	#Alternatively can just change this scruipts properties from another function like Controls in the form of ConfigController.cameraFov = 40

#Run if you want to quickly add new catagories/defaults to the cfg, or reset to default values
func resetConfig():
	var config = ConfigFile.new()
	config.set_value("Settings", "CameraFOV", 90)
	config.set_value("Settings", "local_player_one_name", "Player 1")
	config.set_value("Settings", "local_player_two_name", "Player 2")
	config.set_value("Settings", "game_mode", "American checkers / English draughts")
	config.set_value("Settings", "display_mode", "Windowed")
	config.set_value("Settings", "music_selection", "BraveHeart")
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

# Local Player 1 Name Getter
func getLocalPlayerOneName():
	#print(local_player_one_name)
	return local_player_one_name

# Local Player 1 Name Setter
func setLocalPlayerOneName(value):
	local_player_one_name = value
	updateSettings()

# Local Player 2 Name Getter
func getLocalPlayerTwoName():
	return local_player_two_name

# Local Player 2 Name Setter
func setLocalPlayerTwoName(value):
	local_player_two_name = value
	updateSettings()
	
# Game Mode Getter
func getGameMode():
	return game_mode

# Game Mode Setter
func setGameMode(value):
	game_mode = value
	updateSettings()

# Display Mode Getter
func getDisplayMode():
	return display_mode

# Display Mode Setter
func setDisplayMode(value):
	display_mode = value
	updateSettings()

# Music Selection Getter
func getMusic():
	return music_selection

# Music Selection Setter
func setMusic(value):
	music_selection = value
	updateSettings()
