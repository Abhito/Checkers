extends Spatial

onready var getCam = $Camera
var rayStart = Vector3()
var rayStop = Vector3()
var xCord
var yCord
var held_object = null
#onready var noIntercept = get_tree().get_nodes_in_group("PlayerPieces")

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_tree().get_nodes_in_group("PlayerPieces"):
		node.connect("clicked", self, "_on_pickable_clicked")
		
		
func _on_pickable_clicked(object):
	if !held_object:
		held_object = object
		held_object.pickup()
		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Vector3.ZERO)
			held_object = null

func _physics_process(_delta):
	
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
	
