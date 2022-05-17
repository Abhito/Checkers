extends Spatial

func _on_Area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			print("Player piece clicked")

func _on_Area_mouse_entered():
	get_node("RigidBody/checker/Area/COutline").visible = true

func _on_Area_mouse_exited():
	get_node("RigidBody/checker/Area/COutline").visible = false
	

