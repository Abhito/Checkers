extends Node

#Manages the Server

var network = NetworkedMultiplayerENet.new()
#These values can be changed depending on where the Server is running
var port = 35516
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
	#If player force closes their game during a match
	if pairs.has(player_id):
		var otherplayer_id = pairs.get(player_id)
		rpc_id(otherplayer_id, "endMyGame")
		pairs.erase(otherplayer_id)
		pairs.erase(player_id)

remote func _Create_Lobby(name, requester, isPrivate):
	print("Creating lobby for " + str(name))
	var lobby_id = createRandomID()
	var player_id = get_tree().get_rpc_sender_id()
	#add new lobby to the dictionary
	lobbies[lobby_id] = [player_id, name, isPrivate, lobby_id]
	#send lobby id to requester
	rpc_id(player_id,"ReturnLobbyID", lobby_id, requester)
	
remote func _Join_Lobby(name, lobby_id, requester):
	print("Trying to connect " + str(name) + " to a lobby")
	if lobbies.has(lobby_id):
		print("Lobby Found")
		var lobby = lobbies.get(lobby_id)
		var player1 = lobby[1]
		var player1_id = lobby[0]
		
		if player1_id in get_tree().get_network_connected_peers():
		
			rpc_id(player1_id,"PreConfigure", true, name, get_tree().get_rpc_sender_id())
			pairs[player1_id] = get_tree().get_rpc_sender_id()
		
			rpc_id(get_tree().get_rpc_sender_id(),"PreConfigure", false, player1, player1_id)
			pairs[get_tree().get_rpc_sender_id()] = player1_id
		
			lobbies.erase(lobby_id) #Delete record of lobby once both players are connected
			_Start_Game(player1_id, get_tree().get_rpc_sender_id())
			
		else:
			print("Lobby creator has disconnected. Erasing Lobby")
			lobbies.erase(lobby_id)
			rpc_id(get_tree().get_rpc_sender_id(),"LobbyFailed", requester)
	else:
		print("Lobby Not Found")
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
	print("Match Started")
	rpc_id(player1_id, "StartGame")
	rpc_id(player2_id, "StartGame")
	
remote func _Disconnect_Me():
	var player_id = get_tree().get_rpc_sender_id()
	network.disconnect_peer(player_id)
	
remote func nextTurn(object_path, drop_cord, object_destroyed_path):
	var otherPlayer = pairs.get(get_tree().get_rpc_sender_id())
	rpc_id(get_tree().get_rpc_sender_id(), "ReturnTurn", true, null, null, null)
	#If no piece was moved, Happens if a player times out
	if(object_path == null):
		rpc_id(otherPlayer, "ReturnTurn", true, null, null, null)
	else:
		#If piece was not destroyed
		if(object_destroyed_path == null):
			rpc_id(otherPlayer, "ReturnTurn", true, object_path, drop_cord, null)
		else:
			rpc_id(otherPlayer, "ReturnTurn", true, object_path, drop_cord, object_destroyed_path)

#End game for both players and delete pairs
remote func endGame(mode):
	print("A User is ending the Game")
	var otherPlayer = pairs.get(get_tree().get_rpc_sender_id())
	pairs.erase(get_tree().get_rpc_sender_id())
	network.disconnect_peer(get_tree().get_rpc_sender_id())
	if mode == 0:
		rpc_id(otherPlayer, "endMyGame")
	elif mode == 1:
		rpc_id(otherPlayer, "gameLost")
	pairs.erase(otherPlayer)
	
func lobbyTimer(lobby_id):
	yield(get_tree().create_timer(300.0), "timeout")
	if lobbies.has(lobby_id):
		var player_info = lobbies.get(lobby_id)
		var player_id = player_info[0]
		lobbies.erase(lobby_id)
		rpc_id(player_id, "endMyGame")
		
remote func sendLobbies():
	rpc_id(get_tree().get_rpc_sender_id(), "recieveLobbies", lobbies.values())
