extends Control

export (NodePath) var add_game_options_main_game_mode_options_dropdown_path
export (NodePath) var add_game_options_video_display_mode_options_dropdown_path
export (NodePath) var add_game_options_main_local_player_one_name_path

onready var add_game_options_main_game_mode_options_dropdown = get_node(add_game_options_main_game_mode_options_dropdown_path)
onready var add_game_options_video_display_mode_options_dropdown = get_node(add_game_options_video_display_mode_options_dropdown_path)
onready var add_game_options_main_local_player_one_name = get_node(add_game_options_main_local_player_one_name_path)


# Called when the node enters the scene tree for the first time.
func _ready():
	# Add Display Mode Options
	add_game_options_main_game_mode_options_dropdown()
	add_game_options_video_display_mode_options_dropdown()
	add_game_options_main_local_player_one_name()

# Add Game Mode Options
func add_game_options_main_game_mode_options_dropdown():
	add_game_options_main_game_mode_options_dropdown.add_item("American checkers / English draughts")

# Add Display Mode Options
func add_game_options_video_display_mode_options_dropdown():
	add_game_options_video_display_mode_options_dropdown.add_item("Windowed")
	add_game_options_video_display_mode_options_dropdown.add_item("Fullscreen")
	
# Add Local Player 1 Name to LineEdit
func add_game_options_main_local_player_one_name():
	var localPlayerOneName = ConfigController.getLocalPlayerOneName()
	print(localPlayerOneName)
	add_game_options_main_local_player_one_name.set_text(localPlayerOneName)

#Quick return to menu button
func _on_Return_pressed():
	get_tree().change_scene("res://views/Menu.tscn")

func _on_Button_pressed():
	ConfigController.updateSettings()
	
func _on_Display_Mode_Options_Dropdown_item_selected(index):
	if index == 1:
		OS.window_fullscreen = true
		
	else:
		OS.window_fullscreen = false
