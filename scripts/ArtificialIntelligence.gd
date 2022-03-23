extends Node

var pieceMatrix = Array(Array())
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initAI(gridArray):
	var i = 0
	var j = 0
	var rowArray = Array()
	for grid in gridArray:
		print(grid)
		rowArray.append(grid)
		j = j + 1
		if j == 4:
			pieceMatrix.append(rowArray.duplicate())
			rowArray.clear()
			j = 0
	print("Array Initialized")
	print(pieceMatrix)

func determineMoves():
	#Iterate though 
	pass
	
func movePiece(startGrid, endGrid):
	pass

#Helper Function to visualize whats in the matrix
func printGrid():
	for row in pieceMatrix:
		var rowString = ""
		for grid in row:
			if grid.checkerPresent != null:
				if grid.checkerColor == true:
					rowString = rowString + "X"
				else:
					rowString = rowString + "O"
			else:
				rowString = rowString + "-"
		print(rowString)
