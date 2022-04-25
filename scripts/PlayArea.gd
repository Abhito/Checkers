extends Spatial

onready var getCam = $Rotation/Camera
onready var getAI = $ArtificialIntelligence
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
var held_obj = null
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
	
	if held_object.get_King() == true:
		return kingValidMove(held_object)
	
	#orange piece
	if held_object.get_Color() == true:
		#wrong direction case
		if currentPos[0] < held_object.get_X() || currentPos[2] == held_object.get_Y():
			print("this move is invalid because you went in the wrong direction")
			return false
		elif currentPos[0] + (-held_object.get_X()) >= 4.5 || currentPos[2] - held_object.get_Y() >= 4.5 || (-currentPos[2]) + held_object.get_Y() >=4.5:
			print("This move is too far")
			return false
		elif currentPos[0] + (-held_object.get_X()) >= 3.0:
			var inbetween = grid_find(((currentPos + held_object.get_global_transform().origin)/2))
			if inbetween.checkerColor == false:
				destroy(inbetween.checkerPresent, true)
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
		if currentPos[0] > held_object.get_X() || currentPos[2] == held_object.get_Y():
			print("this move is invalid because you went in the wrong direction")
			return false
		elif (-currentPos[0]) + held_object.get_X() >= 4.5 || currentPos[2] - held_object.get_Y() >= 4.5 || (-currentPos[2]) + held_object.get_Y() >=4.5:
			print("This move is too far")
			return false
		elif (-currentPos[0]) + held_object.get_X() >= 3.0:
			var inbetween = grid_find(((currentPos + held_object.get_global_transform().origin)/2))
			if inbetween.checkerColor == true:
				destroy(inbetween.checkerPresent, false)
				print("Orange piece in between")
				return true
			print("this move is invalid because it went too far")
			return false
		else:
			print("this move is valid")
			return true
			
			
func kingValidMove(held_object):
	
	if held_object.get_Color() == true:
		#wrong direction case
		if currentPos[2] == held_object.get_Y():
			print("this move is invalid because you didn't move foward")
			return false
		elif ((currentPos[0] + (-held_object.get_X()) >= 4.5) || 
			((-currentPos[0]) + held_object.get_X() >= 4.5) || 
			currentPos[2] - held_object.get_Y() >= 4.5 || 
			(-currentPos[2]) + held_object.get_Y() >=4.5):
			print("This move is too far")
			return false
		elif (currentPos[0] + (-held_object.get_X()) >= 3.0) || ((-currentPos[0]) + held_object.get_X() >= 3.0):
			var inbetween = grid_find(((currentPos + held_object.get_global_transform().origin)/2))
			if inbetween.checkerColor == false:
				destroy(inbetween.checkerPresent, true)
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
		if currentPos[2] == held_object.get_Y():
			print("this move is invalid because you didn't move foward")
			return false
		elif (((-currentPos[0]) + held_object.get_X() >= 4.7) || 
			(currentPos[0] + (-held_object.get_X()) >= 4.7) ||
			currentPos[2] - held_object.get_Y() >= 4.7 || 
			(-currentPos[2]) + held_object.get_Y() >=4.7):
			print("This move is too far")
			return false
		elif ((-currentPos[0]) + held_object.get_X() >= 3.0) || (currentPos[0] + (-held_object.get_X()) >= 3.0):
			var inbetween = grid_find(((currentPos + held_object.get_global_transform().origin)/2))
			if inbetween.checkerColor == true:
				destroy(inbetween.checkerPresent, false)
				print("Orange piece in between")
				return true
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
	_intro()
	yield(get_tree().create_timer(5.0), "timeout")
	var musicPath = "res://music/" + ConfigController.music_selection + ".wav"
	AudioManager.playMusic(musicPath)
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
	AudioManager.playMusic("res://music/BraveHeart.wav")
	
func _on_pickable_clicked(object):
	if !held_obj:
		held_obj = object
		currentPos = held_obj.pickup()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_obj and !event.pressed:
			if !validMove(held_obj):
				AudioManager.playSound("res://sounds/InvalidMove.wav")
				held_obj.drop(currentPos)
				held_obj = null
			else:
				var dest = find_closest(held_obj).get_global_transform().origin
				var compare = dest - currentPos
				if(compare.length() < 1):
					print("Can't move to same spot")
					AudioManager.playSound("res://sounds/InvalidMove.wav")
					held_obj.drop(currentPos)
					held_obj = null
				else:
					AudioManager.playSound("res://sounds/CheckerPlace.mp3")
					held_obj.drop(dest)
					if held_obj.get_Color():
						if held_obj.get_X() <= -6:
							held_obj.make_King()
					else:
						if held_obj.get_X() >= 6:
							held_obj.make_King()
					held_obj = null
					nextTurn()
#	if event is InputEventKey and event.scancode == KEY_SPACE and not event.pressed:
#		nextTurn()
	if event is InputEventKey and event.scancode == KEY_ESCAPE and not event.pressed:
		AudioManager.pauseMusic()
		get_node("Rotation/Camera/Pause").visible = true

#TaboutHandeling
func _notification(isfocus):
	if isfocus == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		print("Focus Lost")
		if held_obj:
			held_obj.drop(find_closest(held_obj).get_global_transform().origin)
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
		checkWinLossCondition()
	else:
		getPieceLabel.text = str(P1removed)
		checkWinLossCondition()
	if turnTimer:
		getTimer.reset()
		
#Function checks win and loss conditions for each player
func checkWinLossCondition():
	#if player 2 has had 12 pieces removed
	if(str(P2removed) == "12"):
		print("Player 1 Wins")
		get_node("Rotation/Camera/P1WinScreen").visible = true
	#if player 1 has had 12 pieces removed
	elif(str(P1removed) == "12"):
		get_node("Rotation/Camera/P2WinScreen").visible = true
		print("Player 2 Wins")
		
func destroy(playerpiece, color):
	if playerpiece == null:
		return
	if color:
		P2removed = P2removed + 1
		playerpiece.apply_central_impulse(Vector3(0, -.5, 0))
		playerpiece.global_transform.origin = Vector3(P2Destroy)
		P2Destroy = P2Destroy + Vector3(0, 1, 0)
		playerpiece.interactable = false
	else:
		P1removed = P1removed + 1
		playerpiece.apply_central_impulse(Vector3(0, -.5, 0))
		playerpiece.global_transform.origin = Vector3(P1Destroy)
		P1Destroy = P1Destroy + Vector3(0, 1, 0)
		playerpiece.interactable = false

func _process(_delta):
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
	var _oldcount = turnCount
	
func _intro():
	var orange_pieces = Array()
	var player1 = get_tree().get_root().get_node("Game/Rotation/Camera/Intro/Versus/red/PlayerName")
	player1.text = ConfigController.getLocalPlayerOneName()
	var player2 = get_tree().get_root().get_node("Game/Rotation/Camera/Intro/Versus/blue/PlayerName2")
	player2.text = ConfigController.getLocalPlayerTwoName()
	for piece in get_tree().get_nodes_in_group("OrangePieces"):
		orange_pieces.append(piece)
	var intro = get_tree().get_root().get_node("Game/Rotation/Camera/Intro/Versus/AnimationPlayer")
	intro.play("rotation")
	yield(get_tree().create_timer(5.0), "timeout")
	for piece in orange_pieces:
		piece.turnToggle()
	

