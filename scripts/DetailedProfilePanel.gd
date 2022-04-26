extends ColorRect

var onlineStatus
var awayStatus
var offlineStatus

# Called when the node enters the scene tree for the first time.
func _ready():
	onlineStatus = load("res://images/profile_images/statusOnline.svg")
	awayStatus = load("res://images/profile_images/statusAway.svg")
	offlineStatus = load("res://images/profile_images/statusOffline.svg")
	
	#Change - Testing
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	
	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var http_error = http_request.request("https://via.placeholder.com/500")
	if http_error != OK:
		print("An error occurred in the HTTP request.")
	
	#download_texture("https://checkers-profile-pictures.s3.amazonaws.com/NewImage.jpg", "test_profile_pic")
	
	add_status()
	

# Called when the HTTP request is completed. - Choice 1
func _http_request_completed(result, response_code, headers, body):
	var image = Image.new()
	var image_error = image.load_png_from_buffer(body)
	if image_error != OK:
		print("An error occurred while trying to display the image.")

	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	#Replace TextureRect with a Sprite Node
	$AccountPicture/TextureRect.texture = texture

# Choice 2
func download_texture(url : String, file_name : String):
	var http = HTTPRequest.new()
	add_child(http)
	http.set_download_file(file_name)
	http.request(url)

func add_status():
	$StatusButton.add_icon_item(onlineStatus, "")
	$StatusButton.add_icon_item(awayStatus, "")
	$StatusButton.add_icon_item(offlineStatus, "")

func _on_EditDescriptionButton_pressed():
	get_node("ProfileDescription").visible = false
	get_node("EditDescriptionButton").visible = false
	get_node("ProfileDescriptionEdit").visible = true
	get_node("SaveDescriptionButton").visible = true

func _on_SaveDescriptionButton_pressed():
	get_node("ProfileDescriptionEdit").visible = false
	get_node("SaveDescriptionButton").visible = false
	get_node("ProfileDescription").visible = true
	get_node("EditDescriptionButton").visible = true

func _on_UploadPhoto_pressed():
	$FileSelection.popup()

func _on_FileSelection_file_selected(path):
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		print("Failed to open image.")
	upload_image(image)
	#testing below to display profile picture
	#var texture = ImageTexture.new()
	#texture.create_from_image(image, 0)
	print("It made it here")
	
func upload_image(image):
	image.resize(100, 100, 1)
	image.compress(1, 2, 1.0)
	var headers = ["Content-Type: application/json"]
	#print(image.save_png_to_buffer())
	var base64 = Marshalls.raw_to_base64(image.save_png_to_buffer())
	var body = JSON.print({"imageName": AccountData.username, "image": base64, "type": "base64"})
	#print(body)
	$UploadProfilePicture.request("https://oh339unq37.execute-api.us-east-1.amazonaws.com/alpha/upload-photo", headers, false, HTTPClient.METHOD_PUT, body)

func _on_UploadProfilePicture_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(response_code, " ", json.result)
	
	
#Update description function	
func updateDescription():
	var headers = ["Content-Type: application/json"]
	var updateDesc = ConfigFile.new
	updateDesc.load("")
	updateDesc.save("")
	
	$UpdateDescription.request()
	
func _on_DetailedProfilePanel_visibility_changed():
	$WinNumber.text = str(AccountData.wins)
	$LossNumber.text = str(AccountData.losses)
	print(AccountData.profilePicture)
