extends Spatial

onready var getCam = $Rotation/Camera
onready var getTimer = $Rotation/Camera/TimerOverlay/Timer
onready var getTimerLabel = $Rotation/Camera/TimerOverlay/Timer/TimerLabel
var xCord
var yCord
var held_object = null
var gridLoc = PoolVector3Array()
var turnProcessing = false;
var rotationAmount = 0
var player_pieces = Array()
#current turn bool, true = player 1, false = player 2
var currentTurn = true
var turnTimer = true
var turnCount = 1
var oldCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_tree().get_nodes_in_group("PlayerPieces"):
		node.connect("clicked", self, "_on_pickable_clicked")
	for grid in get_tree().get_nodes_in_group("ValidGrid"):
		gridLoc.append(grid.get_global_transform().origin)
	for piece in get_tree().get_nodes_in_group("PlayerPieces"):
		player_pieces.append(piece)
	if(turnTimer):
		getTimer.start()
	#Set settings according to settings menu
	#Set camera tilt
	#getCam.rotate_z(this)
	#Set FOV
	#getCam.
	#Set Background
	
func _on_pickable_clicked(object):
	if !held_object:
		held_object = object
		held_object.pickup()
		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_object and !event.pressed:
			AudioManager.play("res://sounds/CheckerPlace.mp3")
			print("called")
			held_object.drop(find_closest(held_object))
			held_object = null
	if event is InputEventKey and event.scancode == KEY_SPACE and not event.pressed:
		nextTurn()
	if event is InputEventKey and event.scancode == KEY_ESCAPE and not event.pressed:
		get_node("Rotation/Camera/Pause").visible = true

#TaboutHandeling
func _notification(isfocus):
	if isfocus == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		print("Focus Lost")
		if held_object:
			held_object.drop(find_closest(held_object))
#
func find_closest(piece):
	var position = piece.get_global_transform().origin
	var smallest = 100
	var returnGrid
	for grid in gridLoc:
		var compare = grid.distance_to(position)
		if compare < smallest:
			smallest = compare
			returnGrid = grid
	return returnGrid
	
func nextTurn():
	for piece in player_pieces:
		piece.turnToggle()
	turnProcessing = true
	turnCount = turnCount + 1
	

func _process(delta):
	if turnProcessing == true:
		rotationAmount = rotationAmount + (PI * 0.02)
		$Rotation.rotate_y(PI * 0.02)
		if rotationAmount > PI:
			rotationAmount = 0
			turnProcessing = false


func _on_Timer_timeout():
	if oldCount == turnCount:
		nextTurn()
	var oldcount = turnCount
