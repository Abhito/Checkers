extends Control

onready var getlabel = $LobbyFunctions/CreateLobby/Lobby_ID
onready var getbutton =  $LobbyFunctions/CreateLobby/Create_Lobby
onready var line = $LobbyFunctions/JoinLobby/LineEdit
onready var joinbutton = $LobbyFunctions/JoinLobby/Enter_Button
onready var connecting = $Connecting
onready var refreshbutton = $LobbyFunctions/PublicLobbies/refresh
onready var nameLabel = $LobbyFunctions/LoginInfo/Username

var scene = preload("res://assets/LobbyEntry.tscn")

var private = false
var lobbies
var connection = true

#NOTE: Lobby could use visual improvements

#Connect to Server once you enter Lobby screen
func _ready():
	var animation = get_node("AnimationPlayer").get_animation("Connect")
	animation.set_loop(true)
	get_node("AnimationPlayer").play("Connect")
	if(Server.connected == false):
		Server.ConnectToServer()
	
func _process(delta):
	if(Server.connected):
		connecting.visible = false
		if(connection):
			deactivate(false)
			nameLabel.text = Server.localName
			connection = false
	else:
		connecting.visible = true
	if(Server.lobbyUpdated):
		Server.lobbyUpdated = false
		lobbies = Server.lobbies
		showLobbies()
		
func deactivate(mode):
	getbutton.disabled = mode
	joinbutton.disabled = mode
	refreshbutton.disabled = mode

#Show generated lobby code to user
func _show_Lobby_ID(lobby_id):
	get_node("AnimationPlayer").play("RESET")
	getlabel.text = str(lobby_id)
	deactivate(true)

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
	var animation = get_node("AnimationPlayer").get_animation("Wait")
	animation.set_loop(true)
	get_node("AnimationPlayer").play("Wait")
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
	var lobby_list = get_node("LobbyFunctions/PublicLobbies/LobbyScroll/Lobbylist")
	for n in lobby_list.get_children():
		lobby_list.remove_child(n)
		n.queue_free()
		
	for x in lobbies:
		var isPrivate = x[2]
		if(!isPrivate):
			var lobbyinstance = scene.instance()
			var player_id = x[0]
			var player_name = x[1]
			var lobby_id = str(x[3])
			lobbyinstance.set_entry(player_name, lobby_id)
			lobbyinstance.connect("pressed",self, "join_pressed")
			lobby_list.add_child(lobbyinstance)
	
func join_pressed(id):
	Server.JoinLobby(id, get_instance_id())

#func _on_LobbyList_item_activated(index):
	#var lobby = lobbyList.get_item_text(index)
	#var text = lobby.split(" ", true, 1)
	#var lobby_code = text[0]
	#Server.JoinLobby(lobby_code, get_instance_id())

func _on_refresh_pressed():
	Server.getLobbies()
