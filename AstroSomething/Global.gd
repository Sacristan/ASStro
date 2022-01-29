extends Node

var player: Player = null	
var gameManager: GameManager = null
var stateManager: StateManager = null

const gameScenePath = "res://scenes/levels/level1.tscn"
const menuScenePath = "res://scenes/levels/menu.tscn"

func retryGame():
	get_tree().reload_current_scene()
	
func launchGame():
	get_tree().change_scene(gameScenePath)
	
func launchMenu():
	get_tree().change_scene(menuScenePath)
	
func quitGame():
	get_tree().quit()
	
func wait(time):
	return get_tree().create_timer(time, false)

func enableCursor(flag):
	if(flag):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
