extends Node

var player: Player = null	
var gameManager: GameManager = null

func retryGame():
	get_tree().reload_current_scene()

func wait(time):
	return get_tree().create_timer(time, false)
