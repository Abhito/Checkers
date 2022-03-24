extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 20

var lobbies = {}
var pairs = {}

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
	
remote func _Create_Lobby(name, requester):
	print("Creating lobby for " + name)
	var lobby_id = createRandomID()
	var player_id = get_tree().get_rpc_sender_id()
	lobbies[lobby_id] = [player_id, name]
	rpc_id(player_id,"ReturnLobbyID", lobby_id, requester)
	
remote func _Join_Lobby(name, lobby_id, requester):
	print("Trying to connect " + name + " to a lobby")
	if lobbies.has(lobby_id):
		var lobby = lobbies.get(lobby_id)
		var player1 = lobby[1]
		var player1_id = lobby[0]
		
		rpc_id(player1_id,"PreConfigure", true, name, get_tree().get_rpc_sender_id())
		pairs[player1_id] = get_tree().get_rpc_sender_id()
		
		rpc_id(get_tree().get_rpc_sender_id(),"PreConfigure", false, player1, player1_id)
		pairs[get_tree().get_rpc_sender_id()] = player1_id
		
		lobbies.erase(lobby_id)
		_Start_Game(player1_id, get_tree().get_rpc_sender_id())
	else:
		rpc_id(get_tree().get_rpc_sender_id(),"LobbyFailed", requester)
	
func createRandomID():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var random_id = random.randi_range(1000,9999)
	if random_id in lobbies:
		return createRandomID()
	else:
		return random_id
		
func _Start_Game(player1_id, player2_id):
	rpc_id(player1_id, "StartGame")
	rpc_id(player2_id, "StartGame")
	
remote func _Disconnect_Me():
	var player_id = get_tree().get_rpc_sender_id()
	network.disconnect_peer(player_id)
	
remote func nextTurn():
	var otherPlayer = pairs.get(get_tree().get_rpc_sender_id())
	rpc_id(get_tree().get_rpc_sender_id(), "ReturnTurn", true)
	rpc_id(otherPlayer, "ReturnTurn", true)
	
remote func endGame():
	print("A User is ending the Game")
	var otherPlayer = pairs.get(get_tree().get_rpc_sender_id())
	pairs.erase(get_tree().get_rpc_sender_id())
	network.disconnect_peer(get_tree().get_rpc_sender_id())
	rpc_id(otherPlayer, "endMyGame")
	pairs.erase(otherPlayer)
