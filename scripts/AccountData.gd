extends Node

var username
var email
var status
var friendsList = Array()
var friendRequests = Array()
var profilePicture
var settings
var wins
var losses

func _ready():
	pass

func updateAll(input):
	username = input.Items[0].username.S
	email = input.Items[0].email.S


