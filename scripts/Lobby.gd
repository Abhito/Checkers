extends Control

func _ready():
	pass


func _on_LineEdit_text_entered(new_text):
	Server.ConnectToServer()


func _on_Button_pressed():
	get_tree().change_scene("res://views/Menu.tscn")
