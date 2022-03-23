extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1909

var myTurn
var otherPlayer

func ready():
	pass
	
func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
func _OnConnectionFailed():
	print("Failed to connect")
	get_tree().network_peer = null
	
func _OnConnectionSucceeded():
	print("Succesfully connected")
	_myName()
	
func _myName():
	rpc_id(1, "playerName", ConfigController.getLocalPlayerOneName(), get_instance_id())
	
remote func Myturn(turn, player2):
	myTurn = turn
	otherPlayer = player2
	print("My turn is " + str(myTurn) + " and opponent is " + otherPlayer)
	
remote func StartGame():
	get_tree().change_scene("res://views/PlayAreaClient.tscn")
