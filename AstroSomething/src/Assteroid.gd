extends KinematicBody
class_name Assteroid

signal onExplode(assteroid)

var explosive

func explode():
	pass
	
func assign_explosive(explosive):
	self.explosive = explosive
	add_child(explosive)
	explosive.connect("onExplode", self, "onExplosiveExploded")
	
func onExplosiveExploded():
	print("Asteroid BOOM")
	emit_signal("onExplode", self)
	yield(Global.wait(1),"timeout")
	get_parent().queue_free()

func has_explosive():
	return self.explosive != null
