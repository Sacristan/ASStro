extends Node

var player: Player = null	
var gameManager: GameManager = null
var stateManager: StateManager = null

const levels = {
	"menu": "res://scenes/levels/level1.tscn",
	"level1": "res://scenes/levels/level2.tscn",
}

const menuScenePath = "res://scenes/levels/menu.tscn"

func hasMoreLevels():
	var key = getCurrentSceneName()
	return levels.has(key)

func nextLevel():
	var sceneName = getCurrentSceneName() #outputs root scene node name
	get_tree().change_scene(levels[sceneName])
	
func getCurrentSceneName():
	return get_tree().get_current_scene().get_name()

func retryGame():
	get_tree().reload_current_scene()
	
func launchGame():
	nextLevel()
	
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
