extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_LocalButton_pressed():
	get_tree().change_scene("res://views/PlayArea.tscn")


func _on_AIButton_pressed():
	get_tree().change_scene("res://views/AIPlayArea.tscn")
