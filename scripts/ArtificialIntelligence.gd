extends Node

var pieceMatrix = Array(Array())
var validMoves = Array()

func _ready():
	pass # Replace with function body.

func initAI(gridArray):
	var i = 0
	var j = 0
	var toggle = true
	var rowArray = Array()
	for grid in gridArray:
		#print(grid)
		if toggle:
			rowArray.append(null)
		rowArray.append(grid)
		if not toggle:
			rowArray.append(null)
		j = j + 1
		if j == 4:
			pieceMatrix.append(rowArray.duplicate())
			rowArray.clear()
			j = 0
			if toggle:
				toggle = false
			else:
				toggle = true
	print("Array Initialized")
	#print(pieceMatrix)

func generateValidMoves():
	var i = 0
	var j = 0
	for row in pieceMatrix:
		for grid in row:
			if grid == null:
				pass
			elif grid.checkerPresent != null:
				if grid.checkerColor == false:
					#print("Blue Piece at Row: " + str(i) + " Column: " + str(j))
					if (j - 1) >= 0 and pieceMatrix[i-1][j-1].checkerPresent == null:
						print("Location: " + str(i) + ", " + str(j) + " Normal Move Left")
						var classInstance = ValidMove.new()
						classInstance.addMove(grid)
						classInstance.addMove(pieceMatrix[i-1][j-1])
						if isJumpable(i-1, j-1):
							classInstance.endJumpable()
						validMoves.append(classInstance)
					elif (j - 2) >= 0 and pieceMatrix[i-1][j-1].checkerPresent != null and pieceMatrix[i-1][j-1].checkerColor == true and pieceMatrix[i-2][j-2].checkerPresent == null:
						print("First Check")
						print("Current Row: " + str(i) + " Column: " + str(j))
						print("Jumpable Row: " + str(i - 2) + " Column: " + str(j -2 ))
						var classInstance = ValidMove.new()
						classInstance.addMove(grid)
						classInstance.addMove(pieceMatrix[i-2][j-2])
						classInstance.jumpOccured()
						if isJumpable(i-2, j-2):
							classInstance.endJumpable()
						validMoves.append(classInstance)
					if (j + 1) < 8 and pieceMatrix[i-1][j+1].checkerPresent == null:
						print("Location: " + str(i) + ", " + str(j) + " Normal Move Right")
						var classInstance = ValidMove.new()
						classInstance.addMove(grid)
						classInstance.addMove(pieceMatrix[i-1][j+1])
						if isJumpable(i-1, j+1):
							classInstance.endJumpable()
						validMoves.append(classInstance)
					elif (j + 2) < 8 and pieceMatrix[i-1][j+1].checkerPresent != null and pieceMatrix[i-1][j+1].checkerColor == true and pieceMatrix[i-2][j+2].checkerPresent == null:
						print("Second Check")
						print("Current Row: " + str(i) + " Column: " + str(j))
						print("Jumpable Row: " + str(i - 2) + " Column: " + str(j + 2 ))
						var classInstance = ValidMove.new()
						classInstance.addMove(grid)
						classInstance.addMove(pieceMatrix[i-2][j+2])
						classInstance.jumpOccured()
						if isJumpable(i-2, j+2):
							classInstance.endJumpable()
						validMoves.append(classInstance)
			j = j + 1
		j = 0
		i = i + 1
	print("Valid Moves Quantity: " + str(validMoves.size()))
	#print("First Valid Move: " + str(validMoves[0].moveList))
	#print("Second Valid Move: " + str(validMoves[1].moveList))

func updateMatrix():
	pass

#Potentially implementable recursive function to determine if a second jump can take place.
func anotherJump():
	pass

#Potentially implementable helper function to determine if the piece can currently be jumped on turn resolve.
func isJumpable(xCord, yCord):
	if (yCord + 1) < 8 and (xCord + 1) < 8 and pieceMatrix[xCord-1][yCord+1].checkerPresent != null and pieceMatrix[xCord-1][yCord+1].checkerColor == true and pieceMatrix[xCord+1][yCord-1].checkerPresent == null:
		print("Result Jumpable")
		return true
	elif (yCord + 1) < 8 and (xCord + 1) < 8 and pieceMatrix[xCord-1][yCord-1].checkerPresent != null and pieceMatrix[xCord-1][yCord-1].checkerColor == true and pieceMatrix[xCord+1][yCord+1].checkerPresent == null:
		print("Result Jumpable")
		return true
	else:
		return false

#Where Value Comparison System should reside
func determineBestMove():
	#At the end of calculating valid moves, should clear the list of valid moves.
	clearValidMoves()

func clearValidMoves():
	#Clears the valid moves array and frees up the space.
	for move in validMoves:
		move.free()
	validMoves.clear()

func movePiece(startGrid, endGrid):
	pass

#Helper Function to visualize whats in the matrix
func printGrid():
	for row in pieceMatrix:
		var rowString = ""
		for grid in row:
			if grid == null:
				rowString = rowString + "-"
			elif grid.checkerPresent != null:
				if grid.checkerColor == true:
					rowString = rowString + "X"
				else:
					rowString = rowString + "O"
			else:
				rowString = rowString + "-"
		print(rowString)
