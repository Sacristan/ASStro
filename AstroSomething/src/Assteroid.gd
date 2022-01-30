extends KinematicBody
class_name Assteroid

signal onExplode(assteroid)
export(Array, NodePath) var assteroids
export(float) var cleanupDelay = 1
export(float) var cleanupTime = 0.75

var explosive
onready var particle = $Particle

var time = 0
onready var originalScale = get_parent().scale

func _ready():
	set_process(false)
	
	var index = randi() % assteroids.size()
	var obj = assteroids[index]
	get_node(obj).visible = true
	
func _process(delta):
	time += delta
	
	if time < cleanupDelay:
		pass
	else:
		if time <= cleanupTime + cleanupDelay:
			get_parent().scale = lerp(originalScale, Vector3.ZERO, (time - cleanupDelay) / cleanupTime)
		else:
			cleanup()

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
	set_process(true)
	collision_mask = 0
	get_parent().collision_mask = 0

func cleanup():
	get_parent().queue_free()
	
func has_explosive():
	return self.explosive != null
