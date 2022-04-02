extends ColorRect

var username
var password
var email
var alreadyaccount
signal resume
# Called when the node enters the scene tree for the first time.
func _ready():
	$RegisterRequestHandler.connect("request_completed", self, "_on_request_completed")
	alreadyaccount = null

func _on_RegisterRequestHandler_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print("Request Recieved")
	print(json.result)
	if json != null:
		if json.result == "true":
			#print("Truth Found")
			alreadyaccount = true
			emit_signal("resume")
		elif json.result == "false":
			#print("False Found")
			alreadyaccount = false
			emit_signal("resume")
		else:
			pass

func _on_RegisterAccountButton_pressed():
	username = $UsernameEntry.text
	password = $EPasswordEntry.text
	email = $EmailEntry.text
		
func alreadyUsername():
	var headers = ["Content-Type: application/json"]
	$RegisterRequestHandler.request("https://oh339unq37.execute-api.us-east-1.amazonaws.com/alpha/registration?user=" + username, headers, false, HTTPClient.METHOD_GET)

func _on_HTTPRequestHandler_request_completed(result, response_code, headers, body):
	pass # Replace with function body.


func _on_LoginButton_pressed():
	pass # Replace with function body.
