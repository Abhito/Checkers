extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 6

var player1 = null
var player1_id
var player2 = null
var player2_id

func _ready():
	StartServer()
	
func StartServer():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server Started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")
	
func _Peer_Connected(player_id):
	print("User " + str(player_id) + " Connected")
	
func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " Disconnected")
	
remote func playerName(name, requester):
	if(player1 == null):
		player1 = name
		player1_id = get_tree().get_rpc_sender_id()
	else:
		player2 = name
		player2_id = get_tree().get_rpc_sender_id()
		rpc_id(player1_id, "Myturn", true, player2)
		rpc_id(player2_id, "Myturn", false, player1)
		_Start_Game()
		
func _Start_Game():
	rpc_id(player1_id, "StartGame")
	rpc_id(player2_id, "StartGame")
