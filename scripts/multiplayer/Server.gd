extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1" 
#Change this value once Server app is running on AWS
#var ip = "54.173.65.208"
var port = 35516

var myTurn
var otherPlayer
var otherPlayer_id
var changeTurn
var other_object_path = null
var object_position
var piece_destroyed_path = null
var connected = false

func ready():
	pass
	
#CreateLobby tells the server to create the lobby. 
#@param requester is the reference to Lobby.gd
func CreateLobby(requester):
	print("Creating lobby")
	rpc_id(1, "_Create_Lobby", ConfigController.getLocalPlayerOneName(), requester)

#Returns the LobbyID and calls function to show it
remote func ReturnLobbyID(lobby_id, requester):
	print(lobby_id)
	instance_from_id(requester)._show_Lobby_ID(lobby_id)

#Function to join a lobby using a user given code
func JoinLobby(lobby_id, requester):
	print("Joining Lobby")
	rpc_id(1, "_Join_Lobby", ConfigController.getLocalPlayerOneName(), int(lobby_id), requester)

#Server sends this function to let the client know that no lobby exists with the given code
remote func LobbyFailed(requester):
	print("Lobby failed")
	instance_from_id(requester)._lobby_failed()

#Main function, starts up the connection
func ConnectToServer():
	connected = false
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
#If connection failed, send user back to main menu. Kind of slow
func _OnConnectionFailed():
	print("Failed to connect")
	get_tree().change_scene("res://views/Menu.tscn")
	
#Just prints that connection was succesful
func _OnConnectionSucceeded():
	print("Succesfully connected")
	connected = true

#Once both players have entered a lobby, the Server sends their info to the other
remote func PreConfigure(turn, player2, player2_id):
	myTurn = turn
	otherPlayer = player2
	otherPlayer_id = player2_id
	print("My turn is " + str(myTurn) + " and opponent is " + otherPlayer)
	
remote func StartGame():
	get_tree().change_scene("res://views/PlayAreaClient.tscn")
	
func sendNextTurn(piece_path, drop_cord):
	rpc_id(1, "nextTurn", piece_path, drop_cord, piece_destroyed_path)
	
remote func ReturnTurn(turn, object_path, drop_cord, destroyed_path):
	print("Recieved enemy turn")
	changeTurn = turn
	if(object_path != null):
		other_object_path = object_path
		object_position = drop_cord
		if(destroyed_path != null):
			piece_destroyed_path = destroyed_path

#Called when client wants to diconnect
#disconnectClient is used when player backs out of lobby
func disconnectClient():
	print("Telling Server to disconnect me")
	rpc_id(1, "_Disconnect_Me")
	network = NetworkedMultiplayerENet.new()

#Called when client wants to end game
#sendEndGame is used when player backs out during a game
func sendEndGame():
	print("Telling Server to end game")
	rpc_id(1, "endGame")
	network = NetworkedMultiplayerENet.new()
	
#Server can forcefully end a game
remote func endMyGame():
	print("Ending my game")
	disconnectClient()
	get_tree().change_scene("res://views/Menu.tscn")
	
func win():
	get_tree().change_scene("res://views/Menu.tscn")
	sendEndGame()
