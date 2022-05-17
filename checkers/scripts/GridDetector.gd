extends Spatial

#Null for nothing inside, not null if something is inside
var checkerPresent = null
#True for P1, False for P2
var checkerColor = true

func _on_Area_body_entered(body):
	checkerPresent = body
	if checkerPresent.color:
		checkerColor = true
	else:
		checkerColor = false
	
func _on_Area_body_exited(body):
	checkerPresent = null

