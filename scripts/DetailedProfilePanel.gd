extends ColorRect

var onlineStatus
var awayStatus
var offlineStatus

# Called when the node enters the scene tree for the first time.
func _ready():
	onlineStatus = load("res://images/profile_images/statusOnline.svg")
	awayStatus = load("res://images/profile_images/statusAway.svg")
	offlineStatus = load("res://images/profile_images/statusOffline.svg")
	add_status()

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
	
