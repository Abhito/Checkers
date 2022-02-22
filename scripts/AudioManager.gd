extends Node

var openPlayers = []
var nextSound = []

func play(sound_path):
	nextSound.append(sound_path)

func _ready():
	for i in range(0,4):
		var player = AudioStreamPlayer.new()
		add_child(player)
		openPlayers.append(player)
		player.connect("finished", self, "_on_stream_finished", [player])
		player.bus = "master"

func _on_stream_finished(stream):
	openPlayers.append(stream)

func _process(delta):
	if not nextSound.empty() and not openPlayers.empty():
		openPlayers[0].stream = load(nextSound.pop_front())
		openPlayers[0].play()
		openPlayers.pop_front()
