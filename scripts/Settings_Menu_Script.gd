extends Control

export (NodePath) var add_game_options_main_game_mode_options_dropdown_path
export (NodePath) var add_game_options_video_display_mode_options_dropdown_path
export (NodePath) var add_game_options_main_local_player_one_name_path
export (NodePath) var add_game_options_main_local_player_two_name_path

onready var add_game_options_main_game_mode_options_dropdown = get_node(add_game_options_main_game_mode_options_dropdown_path)
onready var add_game_options_video_display_mode_options_dropdown = get_node(add_game_options_video_display_mode_options_dropdown_path)
onready var add_game_options_main_local_player_one_name = get_node(add_game_options_main_local_player_one_name_path)
onready var add_game_options_main_local_player_two_name = get_node(add_game_options_main_local_player_two_name_path)


# Called when the node enters the scene tree for the first time.
func _ready():
	# Add Display Mode Options
	add_game_options_main_game_mode_options_dropdown()
	add_game_options_video_display_mode_options_dropdown()
	add_game_options_main_local_player_one_name()
	add_game_options_main_local_player_two_name()

# Add Game Mode Options
func add_game_options_main_game_mode_options_dropdown():
	add_game_options_main_game_mode_options_dropdown.add_item("American checkers / English draughts")

# Add Display Mode Options
func add_game_options_video_display_mode_options_dropdown():
	add_game_options_video_display_mode_options_dropdown.add_item("Windowed")
	add_game_options_video_display_mode_options_dropdown.add_item("Fullscreen")
	if ConfigController.getDisplayMode() == "Fullscreen":
		add_game_options_video_display_mode_options_dropdown.select(1)
	
	else:
		add_game_options_video_display_mode_options_dropdown.select(0)
	
# Add Local Player 1 Name to LineEdit
func add_game_options_main_local_player_one_name():
	var localPlayerOneName = ConfigController.getLocalPlayerOneName()
	add_game_options_main_local_player_one_name.set_text(localPlayerOneName)

# Add Local Player 2 Name to LineEdit
func add_game_options_main_local_player_two_name():
	var localPlayerTwoName = ConfigController.getLocalPlayerTwoName()
	add_game_options_main_local_player_two_name.set_text(localPlayerTwoName)

# Quick return to menu button
func _on_Return_pressed():
	get_tree().change_scene("res://views/Menu.tscn")

# Button to update local gamemode 
func _on_Button_pressed():
	ConfigController.setLocalPlayerOneName(add_game_options_main_local_player_one_name.get_text())
	ConfigController.setLocalPlayerTwoName(add_game_options_main_local_player_two_name.get_text())
	ConfigController.updateSettings()
	
# Functionality to display mode
func _on_Display_Mode_Options_Dropdown_item_selected(index):
	if index == 1:
		ConfigController.setDisplayMode("Fullscreen")
		OS.window_fullscreen = true
		
	else:
		ConfigController.setDisplayMode("Windowed")
		OS.window_fullscreen = false
		
# Adjust music via slider
func _on_Music_Slider_value_changed(value):
	#AudioServer.set_bus_volume_db(0, vol)
	pass # Replace with function body.
