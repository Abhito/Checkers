extends Node

#Manages the Server

var network = NetworkedMultiplayerENet.new()
#These values can be changed depending on where the Server is running
var port = 1909
var max_players = 20

#lobbies stores lobby codes and corresponding lobby creator's info
var lobbies = {}
#pairs are players in a lobby together
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
	print("Creating lobby for " + str(name))
	var lobby_id = createRandomID()
	var player_id = get_tree().get_rpc_sender_id()
	#add new lobby to the dictionary
	lobbies[lobby_id] = [player_id, name]
	#send lobby id to requester
	rpc_id(player_id,"ReturnLobbyID", lobby_id, requester)
	
remote func _Join_Lobby(name, lobby_id, requester):
	print("Trying to connect " + str(name) + " to a lobby")
	if lobbies.has(lobby_id):
		var lobby = lobbies.get(lobby_id)
		var player1 = lobby[1]
		var player1_id = lobby[0]
		
		rpc_id(player1_id,"PreConfigure", true, name, get_tree().get_rpc_sender_id())
		pairs[player1_id] = get_tree().get_rpc_sender_id()
		
		rpc_id(get_tree().get_rpc_sender_id(),"PreConfigure", false, player1, player1_id)
		pairs[get_tree().get_rpc_sender_id()] = player1_id
		
		lobbies.erase(lobby_id) #Delete record of lobby once both players are connected
		_Start_Game(player1_id, get_tree().get_rpc_sender_id())
	else:
		rpc_id(get_tree().get_rpc_sender_id(),"LobbyFailed", requester)
	
func createRandomID():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var random_id = random.randi_range(1000,9999)
	#check if lobby already exists
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
	
remote func nextTurn(object_path, drop_cord):
	var otherPlayer = pairs.get(get_tree().get_rpc_sender_id())
	rpc_id(get_tree().get_rpc_sender_id(), "ReturnTurn", true, null, null)
	if(object_path == null):
		rpc_id(otherPlayer, "ReturnTurn", true, null, null)
	else:
		rpc_id(otherPlayer, "ReturnTurn", true, object_path, drop_cord)

#End game for both players and delete pairs
remote func endGame():
	print("A User is ending the Game")
	var otherPlayer = pairs.get(get_tree().get_rpc_sender_id())
	pairs.erase(get_tree().get_rpc_sender_id())
	network.disconnect_peer(get_tree().get_rpc_sender_id())
	rpc_id(otherPlayer, "endMyGame")
	pairs.erase(otherPlayer)
