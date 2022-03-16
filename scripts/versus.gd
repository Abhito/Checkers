extends AnimatedSprite

onready var player = get_parent().get_node("AnimationPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _print():
	show()
	player.play("rotation")
	yield(get_tree().create_timer(5.0), "timeout")
	_invisible()

func _invisible():
	hide()
	var red = get_tree().get_root().get_node("Game/Rotation/Camera/Intro/RedBanner")
	var blue = get_tree().get_root().get_node("Game/Rotation/Camera/Intro/BlueBanner")
	red.hide()
	blue.hide()
