extends Node

var pieceMatrix = Array(Array())

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initAI(gridArray):
	var i = 0
	var j = 0
	var toggle = true
	var rowArray = Array()
	for grid in gridArray:
		print(grid)
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
	print(pieceMatrix)

func generateValidMoves():
	var i = 0
	var j = 0
	for row in pieceMatrix:
		for grid in row:
			if grid == null:
				pass
			elif grid.checkerPresent != null:
				if grid.checkerColor == false:
					print("Blue Piece at Row: " + str(i) + " Column: " + str(j))
					var classInstance = ValidMove.new()
					classInstance.addMove(grid)
			j = j + 1
		j = 0
		i = i + 1

func determineBestMove():
	pass

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
