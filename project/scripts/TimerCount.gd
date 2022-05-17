extends Timer

signal counted_down(number)
export var _count := 30
var origcount

func _ready() -> void:
	connect("timeout", self, "_on_timeout")
	origcount = _count
	
func _on_timeout() -> void:
	emit_signal("counted_down", _count)
	$RTU.text = str(_count)
	_count -= 1
	if _count < 0:
		stop()

func startTimer():
	start()

func reset():
	_count = origcount
	start()
