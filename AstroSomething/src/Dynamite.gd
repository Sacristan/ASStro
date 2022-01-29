extends Spatial

const Timeout = 5

signal onExplode

func _ready():
	yield(Global.wait(Timeout),"timeout")
	boom()

func boom():
	emit_signal("onExplode")
	queue_free()
