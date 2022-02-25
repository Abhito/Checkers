extends Control

export (NodePath) var add_game_options_main_game_mode_options_dropdown_path
export (NodePath) var add_game_options_video_display_mode_options_dropdown_path

onready var add_game_options_main_game_mode_options_dropdown = get_node(add_game_options_main_game_mode_options_dropdown_path)
onready var add_game_options_video_display_mode_options_dropdown = get_node(add_game_options_video_display_mode_options_dropdown_path)


# Called when the node enters the scene tree for the first time.
func _ready():
	# Add Display Mode Options
	add_game_options_main_game_mode_options_dropdown()
	add_game_options_video_display_mode_options_dropdown()

# Add Game Mode Options
func add_game_options_main_game_mode_options_dropdown():
	add_game_options_main_game_mode_options_dropdown.add_item("American checkers / English draughts")

# Add Display Mode Options
func add_game_options_video_display_mode_options_dropdown():
	add_game_options_video_display_mode_options_dropdown.add_item("Windowed")
	add_game_options_video_display_mode_options_dropdown.add_item("Fullscreen")

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
