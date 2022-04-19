extends Control

var username
var friendname
var lobbyID
signal interactionComplete

func _ready():
	pass # Replace with function body.

func updateAll(currentUser, data):
	username = currentUser
	friendname = data.username.S
	$Username.text = friendname
	checkForInvite()


func _on_InviteToGame_pressed():
	if($InviteToGame.text == "Join"):
		Server.JoinLobby(lobbyID, get_instance_id())
	else:
		Server.CreateLobby(get_instance_id(), true)
		$InviteToGame.disabled = true
		

func _show_Lobby_ID(lobby_id):
	Server.friendInvite(friendname, username, lobby_id)
	
func checkForInvite():
	Server.getInvites(get_instance_id())

func getInvite(inviteList):
	for x in inviteList:
		var myName = x[0]
		var friend = x[1]
		var lobbycode = x[2]
		if(myName == username && friend == friendname):
			$InviteToGame.text = "Join"
			lobbyID = lobbycode
			break
			
func _lobby_failed():
	$InviteToGame.text = "Invite to Game"
