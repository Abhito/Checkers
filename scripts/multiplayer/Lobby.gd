extends Control

onready var getlabel = $VBoxContainer/CreateLobby/Lobby_ID
onready var getbutton =  $VBoxContainer/CreateLobby/Create_Lobby
onready var line = $VBoxContainer/JoinGame/JoinLobby/LineEdit
onready var connecting = $Connecting
onready var lobbyList = $VBoxContainer/JoinGame/LobbyList

var private = false
var lobbies

#NOTE: Lobby could use visual improvements

#Connect to Server once you enter Lobby screen
func _ready():
	Server.ConnectToServer()
	
func _process(delta):
	if(Server.connected):
		connecting.visible = false
	else:
		connecting.visible = true
	if(Server.lobbyUpdated):
		Server.lobbyUpdated = false
		lobbies = Server.lobbies
		showLobbies()

#Show generated lobby code to user
func _show_Lobby_ID(lobby_id):
	getlabel.text = str(lobby_id)
	getbutton.disabled = true
	line.editable = false

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
	Server.CreateLobby(get_instance_id(), private)

#Enter the lobby
func _on_Enter_Button_pressed():
	Server.JoinLobby(line.text, get_instance_id())


func _on_IsPrivate_pressed():
	if private:
		private = false
	else:
		private = true
		
func showLobbies():
	lobbyList.clear()
	for x in lobbies:
		var isPrivate = x[2]
		if(!isPrivate):
			var player_id = x[0]
			var player_name = x[1]
			var lobby_id = x[3]
			var item = str(lobby_id) + " " + player_name
			lobbyList.add_item(item, null, true)
	


func _on_LobbyList_item_activated(index):
	var lobby = lobbyList.get_item_text(index)
	var text = lobby.split(" ", true, 1)
	var lobby_code = text[0]
	Server.JoinLobby(lobby_code, get_instance_id())
