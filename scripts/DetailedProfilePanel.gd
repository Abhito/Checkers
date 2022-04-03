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
