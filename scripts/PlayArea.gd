extends Spatial

onready var getCam = $Camera
var rayStart = Vector3()
var rayStop = Vector3()
var xCord
var yCord
#onready var noIntercept = get_tree().get_nodes_in_group("PlayerPieces")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	
	var phyState = get_world().direct_space_state
	
	var mouseLocation = get_viewport().get_mouse_position()
	rayStart = getCam.project_ray_origin(mouseLocation)
	rayStop = rayStart + getCam.project_ray_normal(mouseLocation) * 2000
	var crossData = phyState.intersect_ray(rayStart, rayStop)
	
	if not crossData.empty():
		var loc = crossData.position
		print(loc)
		xCord = loc[0]
		yCord = loc[2]
	
