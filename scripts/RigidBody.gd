extends RigidBody

signal clicked
onready var getCam = get_tree().get_root().get_node("Game/Camera")
var rayStart = Vector3()
var rayStop = Vector3()
var xCord
var yCord
var held = false

func _input_event(camera, event, position, normal, shape_idx):
	#Let PlayArea know when piece is clicked
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("clicked", self)
			
func _physics_process(delta):
	if held:
		var phyState = get_world().direct_space_state
		var mouseLocation = get_viewport().get_mouse_position()
		rayStart = getCam.project_ray_origin(mouseLocation)
		rayStop = rayStart + getCam.project_ray_normal(mouseLocation) * 2000
		var crossData = phyState.intersect_ray(rayStart, rayStop)
		if not crossData.empty():
			var loc = crossData.position
			#print(loc)
			xCord = loc[0]
			yCord = loc[2]
			#Move the piece to the mouse location
			global_transform.origin = Vector3(xCord, 3.5, yCord)

func pickup():
	if held:
		return
	mode = RigidBody.MODE_STATIC
	held = true
	
func drop(impulse = Vector3.ZERO):
	if held:
		mode = RigidBody.MODE_RIGID
		apply_central_impulse(impulse)
		held = false

func _on_RigidBody_mouse_entered():
	get_node("checker/Area/COutline").visible = true


func _on_RigidBody_mouse_exited():
	get_node("checker/Area/COutline").visible = false


func _on_RigidBody_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body)
	var colCords = body.get_global_transform().origin
	global_transform.origin = colCords + Vector3(0, .45, 0)
	print(colCords)
	
