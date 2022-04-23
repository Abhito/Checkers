extends Control

var username
var friendname
signal interactionComplete

func _ready():
	pass # Replace with function body.

func updateAll(currentUser, data):
	username = currentUser
	friendname = data.username.S
	$Username.text = friendname
