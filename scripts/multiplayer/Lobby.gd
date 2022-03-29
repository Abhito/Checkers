extends Control

onready var getlabel = $CenterContainer/VBoxContainer/VBoxContainer/CreateLobby/Lobby_ID
onready var getbutton =  $CenterContainer/VBoxContainer/VBoxContainer/CreateLobby/Create_Lobby
onready var line = $CenterContainer/VBoxContainer/VBoxContainer2/Enter/LineEdit
onready var connecting = $Connecting

#NOTE: Lobby could use visual improvements

#Connect to Server once you enter Lobby screen
func _ready():
	Server.ConnectToServer()
	
func _process(delta):
	if(Server.connected):
		connecting.visible = false

#Show generated lobby code to user
func _show_Lobby_ID(lobby_id):
	getlabel.text = str(lobby_id)
	getbutton.disabled = true

#Let the User know that the code doesn't work
#Can be made to look nicer
func _lobby_failed():
	line.text = "DNE"

#Sends lobby code to Server
func _on_LineEdit_text_entered(new_text):
	print(new_text)
	Server.JoinLobby(new_text, get_instance_id())

#Go back to main menu and disconnect
func _on_Back_Button_pressed():
	get_tree().change_scene("res://views/Menu.tscn")
	Server.disconnectClient()

#Create a Server
func _on_Create_Lobby_pressed():
	Server.CreateLobby(get_instance_id())

#Enter the lobby
func _on_Enter_Button_pressed():
	Server.JoinLobby(line.text, get_instance_id())
