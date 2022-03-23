extends Control

func _ready():
	pass


func _on_LineEdit_text_entered(new_text):
	Server.ConnectToServer()
