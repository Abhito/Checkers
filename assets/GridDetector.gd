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
	print(checkerPresent.get_class())
#	if checkerPresent.playerOwner:
#		print("P1 Checker")
#	else:
#		print("P2 Checker")
	
func _on_Area_body_exited(body):
	checkerPresent = null
	print(checkerPresent)
