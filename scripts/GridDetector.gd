extends Spatial

#Null for nothing inside, not null if something is inside
var checkerPresent = null
#True for P1, False for P2
var checkerColor = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area_body_entered(body):
	checkerPresent = body
	if checkerPresent.color:
		checkerColor = true
	else:
		checkerColor = false
	
func _on_Area_body_exited(body):
	checkerPresent = null

