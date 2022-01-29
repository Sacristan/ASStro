extends Node

var player: Player = null	

func wait(time):
	return get_tree().create_timer(time, false)
