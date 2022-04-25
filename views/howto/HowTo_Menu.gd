extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Next_pressed():
	get_tree().change_scene("res://views/howto/HowTo_Menu2.tscn")

func _on_Previous_Button_pressed():
	get_tree().change_scene("res://views/Menu.tscn")

func _on_Previous2_pressed():
	get_tree().change_scene("res://views/howto/HowTo_Menu.tscn")

func _on_Next2__pressed():
	get_tree().change_scene("res://views/howto/HowTo_Menu3.tscn")

func _on_Previous3_pressed():
	get_tree().change_scene("res://views/howto/HowTo_Menu2.tscn")

func _on_Previous3_Button2_pressed():
	get_tree().change_scene("res://views/Menu.tscn")
