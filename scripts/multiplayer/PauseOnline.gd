extends Control

#This version of Pause is used for disconnecting Botg Clients from the Server

func _on_Menu_pressed():
	get_tree().change_scene("res://views/Menu.tscn")
	Server.sendEndGame() #Let the Server know that the game ended


func _on_Settings_pressed():
	pass # Replace with function body.


func _on_Button_pressed():
	AudioManager.unpauseMusic()
	visible = false
