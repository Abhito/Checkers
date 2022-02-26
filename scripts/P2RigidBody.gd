extends RigidBody

signal clicked
onready var getCam = get_tree().get_root().get_node("Game/Rotation/Camera")
var rayStart = Vector3()
var rayStop = Vector3()
var xCord
var yCord
var held = false
#True for P1 pieces, False for P2 Pieces
var playerOwner = false
var exclusionMap = Array()
var impulse = Vector3(0, -.5, 0)
var turnState = false
#var piece color
var color = false


func _input_event(_camera, event, _position, _normal, _shape_idx):
	#Let PlayArea know when piece is clicked
	if event is InputEventMouseButton and turnState:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("clicked", self)
	
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
	print("My xpos before you picked me up: ", (global_transform.origin)[0])
	mode = RigidBody.MODE_STATIC
	held = true
	return (global_transform.origin)
	
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
		
func get_X():
	return xCord

func get_Color():
	return color

func _on_P2RigidBody_mouse_entered():
	if turnState == true:
		get_node("checker/Area/COutline").visible = true


func _on_P2RigidBody_mouse_exited():
	if turnState == true:
		get_node("checker/Area/COutline").visible = false
