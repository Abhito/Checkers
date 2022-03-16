extends KinematicBody2D

export (int) var speed = -550
var velocity = Vector2(1, 0)
var start = false
onready var node = get_tree().get_root().get_node("Game/Rotation/Camera/Intro/Versus/AnimatedSprite")

func _ready():
	velocity = velocity.normalized() * speed
	

func _physics_process(delta):
	if start:
		var collision = move_and_collide(velocity*delta)
		if collision != null:
			print("I collided with ", collision.collider.name)
			node._print()
			start = false

func _start():
	start = true
