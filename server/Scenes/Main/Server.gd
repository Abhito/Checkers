extends Node

#Manages the Server

var network = NetworkedMultiplayerENet.new()
#These values can be changed depending on where the Server is running
var port = 35516
var max_players = 20

#lobbies stores lobby codes and corresponding lobby creator's info
var lobbies = {}
var friendlobbies = {}
#pairs are players in a lobby together
var pairs = {}
var users = {}
var ids = {}

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
		cleanLobbies(player_id)
		cleanLobbies(otherplayer_id)
		
		if ids.has(player_id):
			var name = ids.get(player_id)
			ids.erase(player_id)
			users.erase(name)

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
			clearFriend(lobby_id)
			_Start_Game(player1_id, get_tree().get_rpc_sender_id())
			
		else:
			print("Lobby creator has disconnected. Erasing Lobby")
			lobbies.erase(lobby_id)
			clearFriend(lobby_id)
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
	cleanLobbies(player_id)
	
func cleanLobbies(player_id):
	var ids = lobbies.values()
	for i in ids:
		if i[0] == player_id:
			var lobby = i[3]
			lobbies.erase(lobby)
			clearFriend(lobby)
			print("Deleting lobby: " + str(lobby))
	
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
remote func endGame():
	print("A User is ending the Game")
	var otherPlayer = pairs.get(get_tree().get_rpc_sender_id())
	pairs.erase(get_tree().get_rpc_sender_id())
	network.disconnect_peer(get_tree().get_rpc_sender_id())
	rpc_id(otherPlayer, "endMyGame")
	pairs.erase(otherPlayer)
	
func lobbyTimer(lobby_id):
	yield(get_tree().create_timer(300.0), "timeout")
	if lobbies.has(lobby_id):
		var player_info = lobbies.get(lobby_id)
		var player_id = player_info[0]
		lobbies.erase(lobby_id)
		clearFriend(lobby_id)
		rpc_id(player_id, "endMyGame")
		
remote func login(name):
	print(name + " is online")
	users[name] = get_tree().get_rpc_sender_id()
	ids[get_tree().get_rpc_sender_id()] = name
		
remote func sendLobbies():
	rpc_id(get_tree().get_rpc_sender_id(), "recieveLobbies", lobbies.values())
	
remote func friend_invite(friendName, username, lobby_id):
	friendlobbies[lobby_id] = [friendName, username, lobby_id]
	if users.has(friendName):
		rpc_id(users.get(friendName), "invited", friendlobbies.get(lobby_id))
	
func clearFriend(lobby_id):
	if friendlobbies.has(lobby_id):
		friendlobbies.erase(lobby_id)
	
remote func sendInvites(requester):
	rpc_id(get_tree().get_rpc_sender_id(), "recieveInvites", requester, friendlobbies.values())
