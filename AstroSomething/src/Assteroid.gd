extends KinematicBody

func wait(time):
	return get_tree().create_timer(time, false)
