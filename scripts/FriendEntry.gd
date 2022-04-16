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
	
func addFriend(username, friendname):
	pass

func removeRequest(username, friendname):
	pass

func _on_FriendRequestHTTP_request_completed(result, response_code, headers, body):
	emit_signal("interactionComplete")

func _on_AcceptFriend_pressed():
	var headers = ["Content-Type: application/json"]
	$FriendRequestHTTP.request("https://oh339unq37.execute-api.us-east-1.amazonaws.com/alpha/add-friend?user=" + username + "&friend=" + friendname, headers, false, HTTPClient.METHOD_PUT)
	yield(self, "interactionComplete")
	queue_free()
	
func _on_DeclineFriend_pressed():
	pass # Replace with function body.
