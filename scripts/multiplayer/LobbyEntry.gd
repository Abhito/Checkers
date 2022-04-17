extends Control

signal pressed
var lobby_id

func set_entry(username, id):
	var nametag = get_node("Panel/HBoxContainer/name")
	nametag.text = username
	lobby_id = id


func _on_join_pressed():
	emit_signal("pressed", lobby_id)
