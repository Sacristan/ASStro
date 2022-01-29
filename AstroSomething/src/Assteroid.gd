extends KinematicBody

signal onExplode

func explode():
	pass
	
func assign_explosive(explosive):
	add_child(explosive)
	explosive.connect("onExplode", self, "onExplosiveExploded")
	
func onExplosiveExploded():
	print("Asteroid BOOM")
	emit_signal("onExplode")
	yield(Global.wait(1),"timeout")
	get_parent().queue_free()
