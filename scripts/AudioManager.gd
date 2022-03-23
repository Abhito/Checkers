extends Node

var openPlayers = []
var nextSound = []
var sfxVolume = -20
var musicVolume = -20
var musicPosition = 0
var currentMusic
var musicPlayer = AudioStreamPlayer

func playSound(sound_path):
	nextSound.append(sound_path)

func playMusic(music_path):
	currentMusic = music_path
	musicPlayer.stream = load(music_path)
	musicPlayer.play()
	
func stopMusic():
	musicPlayer.stop()

func pauseMusic():
	musicPosition = musicPlayer.get_playback_position()
	musicPlayer.stop()

func unpauseMusic():
	musicPlayer.stream = load(currentMusic)
	musicPlayer.play(musicPosition)
	
func _ready():
	musicPlayer = AudioStreamPlayer.new()
	add_child(musicPlayer)
	for i in range(0,4):
		var player = AudioStreamPlayer.new()
		add_child(player)
		openPlayers.append(player)
		player.connect("finished", self, "_on_stream_finished", [player])
		player.bus = "master"
		player.volume_db = sfxVolume
	musicPlayer.bus = "master"
	musicPlayer.volume_db = musicVolume

func _on_stream_finished(stream):
	openPlayers.append(stream)

func _process(delta):
	if not nextSound.empty() and not openPlayers.empty():
		openPlayers[0].stream = load(nextSound.pop_front())
		openPlayers[0].play()
		openPlayers.pop_front()
