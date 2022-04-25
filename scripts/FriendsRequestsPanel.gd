extends ColorRect
var scene = preload("res://assets/FriendRequest.tscn")
# Called when the node enters the scene tree for the first time.

func _ready():
	#var friendInstance = scene.instance()
	#var friendInstanceTwo = scene.instance()
	for i in range(10):
		#var text = Label.new()
		#text.text = "Wow"
		var friendRequestInstance = scene.instance()
		get_node("FriendRequestScroll/FriendRequestContainer").add_child(friendRequestInstance)
