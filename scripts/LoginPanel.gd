extends ColorRect

var username
var password
var tempHold
var discoveredEmail
var discoveredProfile
var MenuAnimationPlayer
signal verified
signal updatedUser

# Called when the node enters the scene tree for the first time.

func _ready():
	tempHold = true
	MenuAnimationPlayer = get_node("../../MenuAnimator/AnimationPlayer")

func _on_LoginButton_pressed():
	username = $UsernameEntry.text
	password = $PasswordEntry.text
	var headers = ["Content-Type: application/json"]
	if username != "" and password != "":
		var verify = verifyPassword()
		yield(self, "verified")
		if tempHold == true:
			print("Verification Successful")
			$LoginRequestHandler.request("https://oh339unq37.execute-api.us-east-1.amazonaws.com/alpha/verification?user=" + username, headers, false, HTTPClient.METHOD_GET)
		elif tempHold == false:
			print("Verification Failed")
	else:
		print("Invalid Input")

func _on_LoginRequestHandler_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	#print(typeof(json.result))
	#print(json.result)
	if typeof(json.result) == 18:
		#print("Dictionary Found")
		print(json.result)
		AccountData.updateAll(json.result)
		get_node("../ProfilePanel/Username").text = AccountData.username
		emit_signal("updatedUser")
		
		MenuAnimationPlayer.play("loginToProfile")
		
		#Connect to multiplayer server
		AccountData.isLoggedIn = true
		Server.ConnectToServer()
		
	elif json != null:
		if json.result == "false":
			print("False Found")
			tempHold = false
			emit_signal("verified")
		elif json.result == null:
			print("Null Found")
			tempHold = false
			emit_signal("verified")
		else:
			print(json.result)
	else:
		pass

func verifyPassword():
	#Verify they match then send everything back but the password? Until we do a heftier implementation w/t auth tokens
	#Also should move the HTTPS parameters to the query field so that they can be encoded
	var headers = ["Content-Type: application/json"]
	$LoginRequestHandler.request("https://oh339unq37.execute-api.us-east-1.amazonaws.com/alpha/verification?user=" + username + "&pass=" + password, headers, false, HTTPClient.METHOD_GET)
