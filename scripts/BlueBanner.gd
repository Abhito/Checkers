extends KinematicBody2D

export (int) var speed = 500
var velocity = Vector2(1, 0)
var start = true

func _ready():
	velocity = velocity.normalized() * speed
	

func _physics_process(delta):
	if start:
		var collision = move_and_collide(velocity*delta)
		if collision:
			print("I collided with ", collision.collider.name)
			emit_signal("collided", self)
			start = false
