extends Spatial

onready var getCam = $Rotation/Camera
onready var getTimer = $Rotation/Camera/TimerOverlay/Timer
onready var getTimerLabel = $Rotation/Camera/TimerOverlay/Timer/TimerLabel
var xCord
var yCord
var held_object = null
var gridLoc = PoolVector3Array()
var grids = Array()
var turnProcessing = false;
var rotationAmount = 0
var player_pieces = Array()
#current xpos
var currentPos
#current turn bool, true = player 1, false = player 2
var currentTurn = true
var turnTimer = true
var turnCount = 1
var oldCount = 0
var cameraFOV = ConfigController.cameraFOV
#onready var noIntercept = get_tree().get_nodes_in_group("PlayerPieces")


func validMove(held_object):
	print("this piece's x value is ", held_object.get_X(), " when you dropped it")
	
	#orange piece
	if held_object.get_Color() == true:
		#wrong direction case
		if currentPos[0] < held_object.get_X():
			print("this move is invalid because you went in the wrong direction")
			return false
		elif currentPos[0] + (-held_object.get_X()) >= 3.0:
			var inbetween = grid_find(((currentPos + held_object.get_global_transform().origin)/2))
			if inbetween.checkerColor == false:
				destroy(inbetween.checkerPresent)
				print("Blue piece in between")
				return true
			print("this move is invalid because it went too far")
			return false
		else:
			print("this move is valid")
			return true
	
	#blue piece
	else:
		#wrong direction case
		if currentPos[0] > held_object.get_X():
			print("this move is invalid because you went in the wrong direction")
			return false
	
		elif (-currentPos[0]) + held_object.get_X() >= 3.0:
			print("this move is invalid because it went too far")
			return false
		else:
			print("this move is valid")
			return true

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_tree().get_nodes_in_group("PlayerPieces"):
		node.connect("clicked", self, "_on_pickable_clicked")
	for grid in get_tree().get_nodes_in_group("ValidGrid"):
		grids.append(grid)
	for piece in get_tree().get_nodes_in_group("PlayerPieces"):
		player_pieces.append(piece)
	#Stub for turn Timer, unfinished
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
		currentPos = held_object.pickup()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_object and !event.pressed:
			if !validMove(held_object):
				held_object.drop(currentPos)
				held_object = null
			else:
				AudioManager.play("res://sounds/CheckerPlace.mp3")
				held_object.drop(find_closest(held_object).get_global_transform().origin)
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
			held_object.drop(find_closest(held_object).get_global_transform().origin)
#
func find_closest(piece):
	var position = piece.get_global_transform().origin
	var smallest = 100
	var returnGrid
	for grid in grids:
		var compare = (grid.get_global_transform().origin).distance_to(position)
		if compare < smallest:
			smallest = compare
			returnGrid = grid
	return returnGrid
	
func grid_find(loc):
	var smallest = 1000
	var returnGrid
	for grid in grids:
		var compare = (grid.get_global_transform().origin).distance_to(loc)
		if compare < smallest:
			smallest = compare
			returnGrid = grid
	return returnGrid

func nextTurn():
	for piece in player_pieces:
		piece.turnToggle()
	turnProcessing = true
	turnCount = turnCount + 1
	
func destroy(playerpiece):
	print("Remove this player piece: ", playerpiece)

func _process(delta):
	if turnProcessing == true:
		rotationAmount = rotationAmount + (PI * 0.02)
		$Rotation.rotate_y(PI * 0.02)
		if rotationAmount > PI:
			rotationAmount = 0
			turnProcessing = false

#Stub for turn Timer, unfinished
func _on_Timer_timeout():
	if oldCount == turnCount:
		nextTurn()
	var oldcount = turnCount
