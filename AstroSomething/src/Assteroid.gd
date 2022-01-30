extends KinematicBody
class_name Assteroid

signal onExplode(assteroid)
export(Array, NodePath) var assteroids

var explosive
onready var particle = $Particle

func _ready():
	var index = randi() % assteroids.size()
	var obj = assteroids[index]
	get_node(obj).visible = true

func explode():
	pass
	
func assign_explosive(explosive):
	self.explosive = explosive
	add_child(explosive)
	explosive.connect("onExplode", self, "onExplosiveExploded")
	
func onExplosiveExploded():
	particle.emitting = true
	print("Asteroid BOOM")
	emit_signal("onExplode", self)
	yield(Global.wait(2),"timeout")
	get_parent().queue_free()

func has_explosive():
	return self.explosive != null
