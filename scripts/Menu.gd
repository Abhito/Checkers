extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var MenuAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.stopMusic()
	MenuAnimationPlayer = get_tree().get_root().get_node("Menu/MenuAnimator/AnimationPlayer")
	MenuAnimationPlayer.play("reset")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#transfers to different scene based on which button is pressed (for now, they all go to the same test scene until we have the other components)
func _on_Solo_pressed():
	get_tree().change_scene("res://views/SinglePlayerMenu.tscn")

func _on_Online_pressed():
	get_tree().change_scene("res://views/Lobby.tscn")

func _on_Options_pressed():
	print("Options Pressed")
	get_tree().change_scene("res://views/Settings_Menu.tscn")

func _on_HowTo_pressed():
	get_tree().change_scene("res://views/howto/HowTo_Menu.tscn")

func _on_Exit_pressed():
	get_tree().quit()

func _on_AccountButton_pressed():
	MenuAnimationPlayer.play("growLogin")

func _on_RegisterButton_pressed():
	MenuAnimationPlayer.play("growRegister")

func _on_LoginToProfile_pressed():
	MenuAnimationPlayer.play("shrinkLogin")

func _on_RegisterToProfile_pressed():
	MenuAnimationPlayer.play("shrinkRegister")

func _on_exitFriendsButton_pressed():
	MenuAnimationPlayer.play("friendsToProfile")

func _on_FriendsButton_pressed():
	MenuAnimationPlayer.play("profileToFriends")

func _on_FriendRequests_pressed():
	$UserPanels/FriendsPanel.visible = false
	$UserPanels/FriendsRequestsPanel.visible = true

func _on_exitFriendRequestButton_pressed():
	$UserPanels/FriendsRequestsPanel.visible = false
	$UserPanels/FriendsPanel.visible = true

func _on_ProfileButton_pressed():
	MenuAnimationPlayer.play("profileToDetailedProfile")
	get_node("UserPanels/DetailedProfilePanel/UserName").text = AccountData.username

func _on_ReturnToProfile_pressed():
	MenuAnimationPlayer.play("detailedProfileToProfile")
