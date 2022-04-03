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
