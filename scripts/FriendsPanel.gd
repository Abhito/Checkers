extends ColorRect
var scene = preload("res://assets/FriendEntry.tscn")
signal friendRecieved
var friendData
# Called when the node enters the scene tree for the first time.

func _ready():
	pass

func _on_LoginPanel_updatedUser():
	var headers = ["Content-Type: application/json"]
	$FriendHandler.request("https://oh339unq37.execute-api.us-east-1.amazonaws.com/alpha/update-friends?friend=" + arrayToString(AccountData.friendsList), headers, false, HTTPClient.METHOD_GET)
	yield(self, "friendRecieved")
	for i in friendData.size():
		print(i)
		var friendInstance = scene.instance()
		friendInstance.updateAll(AccountData.username, friendData[i].Items[0])
		get_node("FriendScroll/FriendContainer").add_child(friendInstance)


func _on_FriendHandler_request_completed(result, response_code, headers, body):
	print("Request Complete")
	var json = JSON.parse(body.get_string_from_utf8())
	if json == null:
		print("Null return")
	print(json.result)
	friendData = json.result
	emit_signal("friendRecieved")
	
func arrayToString(array):
	var send = ""
	for i in array.size():
		if i == 0:
			pass
		elif(i == array.size() - 1):
			send = send + array[i]
		else:
			send = send + array[i] + ","
	print(send)
	return send
