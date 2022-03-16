extends AnimatedSprite


# Declare member variables here. Examples:
var rotate = 10
onready var player = get_parent().get_node("AnimationPlayer")
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _print():
	show()
	player.play("rotation")
	yield(get_tree().create_timer(6.0), "timeout")
	_invisible()

func _invisible():
	hide()
	var red = get_tree().get_root().get_node("Game/Rotation/Camera/Intro/RedBanner")
	var blue = get_tree().get_root().get_node("Game/Rotation/Camera/Intro/BlueBanner")
	red.hide()
	blue.hide()
