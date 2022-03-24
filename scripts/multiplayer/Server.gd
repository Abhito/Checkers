extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909

var connected = false
var myTurn
var otherPlayer
var otherPlayer_id
var changeTurn

func ready():
	pass
	
func CreateLobby(requester):
	print("Creating lobby")
	rpc_id(1, "_Create_Lobby", ConfigController.getLocalPlayerOneName(), requester)
	
remote func ReturnLobbyID(lobby_id, requester):
	print(lobby_id)
	instance_from_id(requester)._show_Lobby_ID(lobby_id)
	
func JoinLobby(lobby_id, requester):
	print("Joining Lobby")
	rpc_id(1, "_Join_Lobby", ConfigController.getLocalPlayerOneName(), int(lobby_id), requester)
	
remote func LobbyFailed(requester):
	print("Lobby failed")
	instance_from_id(requester)._lobby_failed()
	
func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
	
func _OnConnectionFailed():
	print("Failed to connect")
	get_tree().change_scene("res://views/Menu.tscn")
	
	
func _OnConnectionSucceeded():
	print("Succesfully connected")
	
remote func PreConfigure(turn, player2, player2_id):
	myTurn = turn
	otherPlayer = player2
	otherPlayer_id = player2_id
	print("My turn is " + str(myTurn) + " and opponent is " + otherPlayer)
	
remote func StartGame():
	get_tree().change_scene("res://views/PlayAreaClient.tscn")
	
func sendNextTurn():
	rpc_id(1, "nextTurn")
	
remotesync func ReturnTurn(turn):
	changeTurn = turn
	
func disconnectClient():
	rpc_id(1, "_Disconnect_Me")
	network = NetworkedMultiplayerENet.new()

func sendEndGame():
	rpc_id(1, "endGame")
	network = NetworkedMultiplayerENet.new()
	
remote func endMyGame():
	print("Ending my game")
	disconnectClient()
	get_tree().change_scene("res://views/Menu.tscn")
	
