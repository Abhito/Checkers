extends Control

onready var getlabel = $CenterContainer/VBoxContainer/HBoxContainer/Lobby_ID
onready var getbutton =  $CenterContainer/VBoxContainer/HBoxContainer/Create_Lobby
onready var line = $CenterContainer/VBoxContainer/LineEdit

func _ready():
	Server.ConnectToServer()
	
func _show_Lobby_ID(lobby_id):
	getlabel.text = str(lobby_id)
	getbutton.disabled = true

func _lobby_failed():
	line.text = "DNE"

func _on_LineEdit_text_entered(new_text):
	print(new_text)
	Server.JoinLobby(new_text, get_instance_id())

func _on_Back_Button_pressed():
	get_tree().change_scene("res://views/Menu.tscn")
	Server.disconnectClient()


func _on_Create_Lobby_pressed():
	Server.CreateLobby(get_instance_id())
