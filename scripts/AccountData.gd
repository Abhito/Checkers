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
var isLoggedIn = false

func _ready():
	wins = 0
	losses = 0

func updateAll(input):
	username = input.Items[0].username.S
	email = input.Items[0].email.S
	friendsList = input.Items[0].friends.SS
	friendRequests = input.Items[0].friendrequests.SS
	wins = input.Items[0].wins.N
	losses = input.Items[0].losses.N

func logOut():
	username = null
	email = null
	friendsList = null
	friendRequests = null
	wins = null
	losses = null
	isLoggedIn = false

