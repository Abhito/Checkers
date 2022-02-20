extends RigidBody

signal clicked
onready var getCam = get_tree().get_root().get_node("Game/Rotation/Camera")
var rayStart = Vector3()
var rayStop = Vector3()
var xCord
var yCord
var held = false
var exclusionMap = Array()
var impulse = Vector3(0, -.5, 0)
var turnState = false


	
func _physics_process(_delta):
	if held:
		var phyState = get_world().direct_space_state
		var mouseLocation = get_viewport().get_mouse_position()
		rayStart = getCam.project_ray_origin(mouseLocation)
		rayStop = rayStart + getCam.project_ray_normal(mouseLocation) * 2000
		var crossData = phyState.intersect_ray(rayStart, rayStop)
		if not crossData.empty():
			var loc = crossData.position
			xCord = loc[0]
			yCord = loc[2]
			#Move the piece to the mouse location
			global_transform.origin = Vector3(xCord, 3, yCord)

func pickup():
	if held:
		return
	mode = RigidBody.MODE_STATIC
	held = true
	
func drop(destination):
	if held:
		mode = RigidBody.MODE_RIGID
		apply_central_impulse(impulse)
		global_transform.origin = Vector3(destination) + Vector3(0, 1, 0)
		held = false

func turnToggle():
	if turnState == true:
		turnState = false
	else:
		turnState = true

func _on_P2RigidBody_mouse_entered():
	if turnState == true:
		get_node("checker/Area/COutline").visible = true


func _on_P2RigidBody_mouse_exited():
	if turnState == true:
		get_node("checker/Area/COutline").visible = false


func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and turnState:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("clicked", self)
