extends Spatial

export(float) var explosionTimeout = 5

signal onExplode()

func _ready():
	yield(Global.wait(explosionTimeout),"timeout")
	boom()

func boom():
	emit_signal("onExplode")
	queue_free()
