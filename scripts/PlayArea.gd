extends Spatial

onready var getCam = $Rotation/Camera
onready var getTimer = $Rotation/Camera/GameInformation/Timer
onready var getTimerLabel = $Rotation/Camera/GameInformation/Timer/RTU
onready var getTurnLabel = $Rotation/Camera/GameInformation/TCU
onready var getPieceLabel = $Rotation/Camera/GameInformation/PPU
var P1removed
var P2removed
var P1Destroy
var P2Destroy
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
var oldCount = 1
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
				destroy(inbetween.checkerPresent, true)
				P2removed = P2removed + 1
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
			var inbetween = grid_find(((currentPos + held_object.get_global_transform().origin)/2))
			if inbetween.checkerColor == true:
				destroy(inbetween.checkerPresent, false)
				P1removed = P1removed + 1
				print("Orange piece in between")
				return true
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
	P1Destroy = (($ChessBoard/P1Holder).get_global_transform().origin + Vector3(0,1,0))
	P2Destroy = (($ChessBoard/P2Holder).get_global_transform().origin + Vector3(0,1,0))
	getTurnLabel.text = str(turnCount)
	getPieceLabel.text = str(0)
	getTimerLabel.text = str(30)
	P1removed = 0
	P2removed = 0
	
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
				nextTurn()
#	if event is InputEventKey and event.scancode == KEY_SPACE and not event.pressed:
#		nextTurn()
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
	if currentTurn:
		currentTurn = false
	else:
		currentTurn = true
	for piece in player_pieces:
		piece.turnToggle()
	turnProcessing = true
	turnCount = turnCount + 1
	getTurnLabel.text = str(turnCount)
	if currentTurn:
		getPieceLabel.text = str(P2removed)
	else:
		getPieceLabel.text = str(P1removed)
	if turnTimer:
		getTimer.reset()
	
func destroy(playerpiece, color):
	if color:
		playerpiece.MODE_RIGID
		playerpiece.apply_central_impulse(Vector3(0, -.5, 0))
		playerpiece.global_transform.origin = Vector3(P2Destroy)
		P2Destroy = P2Destroy + Vector3(0, 1, 0)
		playerpiece.interactable = false
	else:
		playerpiece.MODE_RIGID
		playerpiece.apply_central_impulse(Vector3(0, -.5, 0))
		playerpiece.global_transform.origin = Vector3(P1Destroy)
		P1Destroy = P1Destroy + Vector3(0, 1, 0)
		playerpiece.interactable = false

func _process(delta):
	if turnProcessing == true:
		rotationAmount = rotationAmount + (PI * 0.02)
		$Rotation.rotate_y(PI * 0.02)
		if rotationAmount > PI:
			rotationAmount = 0
			turnProcessing = false

#Stub for turn Timer, unfinished
func _on_Timer_timeout():
	if getTimer._count == 0:
		nextTurn()
