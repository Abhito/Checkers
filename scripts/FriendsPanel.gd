extends ColorRect
var scene = preload("res://assets/FriendEntry.tscn")
# Called when the node enters the scene tree for the first time.

func _ready():
	#var friendInstance = scene.instance()
	#var friendInstanceTwo = scene.instance()
	for i in range(10):
		#var text = Label.new()
		#text.text = "Wow"
		#get_node("FriendScroll/FriendContainer").add_child(text)
		var friendInstance = scene.instance()
		get_node("FriendScroll/FriendContainer").add_child(friendInstance)


