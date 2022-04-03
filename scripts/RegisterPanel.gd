extends ColorRect

var username
var password
var passwordComf
var email
var alreadyaccount
var regErrorText
signal resume
# Called when the node enters the scene tree for the first time.
func _ready():
	$RegisterRequestHandler.connect("request_completed", self, "_on_request_completed")
	alreadyaccount = null
	regErrorText = get_node("RegErrorText")

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
	passwordComf = $CPasswordEntry.text
	email = $EmailEntry.text
	var headers = ["Content-Type: application/json"]
	if username == "" or password == "" or email == "":
		regErrorText.text = "A required field was left empty"
		regErrorText.add_color_override("font_color", Color(0.9, 0.1, 0.1, 1))
		regErrorText.visible = true
	elif username.length() < 5:
		regErrorText.text = "Username does not meet requirements"
		regErrorText.add_color_override("font_color", Color(0.9, 0.1, 0.1, 1))
		regErrorText.visible = true
	elif password != passwordComf:
		regErrorText.text = "Password and confirmation do not match"
		regErrorText.add_color_override("font_color", Color(0.9, 0.1, 0.1, 1))
		regErrorText.visible = true
	elif password.length() < 5:
		regErrorText.text = "Password does not meet requirements"
		regErrorText.add_color_override("font_color", Color(0.9, 0.1, 0.1, 1))
		regErrorText.visible = true
	elif !("@" in email):
		regErrorText.text = "Email is not real"
		regErrorText.add_color_override("font_color", Color(0.9, 0.1, 0.1, 1))
		regErrorText.visible = true
	else:
		var getuser = alreadyUsername()
		#yield(get_tree().create_timer(3), "timeout")
		yield(self, "resume")
		print("Resumed")
		if alreadyaccount == true:
			print("There is already an account registered to this username")
		elif alreadyaccount == false:
			$RegisterRequestHandler.request("https://oh339unq37.execute-api.us-east-1.amazonaws.com/alpha/registration?user=" + username + "&pass=" + password + "&email=" + email, headers, false, HTTPClient.METHOD_PUT)
			print("Account Creation Successful")
			var loginText = get_node("../LoginPanel/LoginErrorText")
			loginText.visible = true
			loginText.text = "Account Successfully Created"
			loginText.add_color_override("font_color", Color(0.2, 0.75, 0.2, 1))
			get_node("../../MenuAnimator/AnimationPlayer").play("registerToLogin")

func alreadyUsername():
	var headers = ["Content-Type: application/json"]
	$RegisterRequestHandler.request("https://oh339unq37.execute-api.us-east-1.amazonaws.com/alpha/registration?user=" + username, headers, false, HTTPClient.METHOD_GET)
