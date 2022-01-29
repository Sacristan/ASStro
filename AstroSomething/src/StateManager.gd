extends Node
class_name StateManager

signal onPause(isPaused)

func _ready():
	Global.stateManager = self
	pause(false)
	self.connect("tree_exiting", self, "onTreeExiting")
	
	yield(Global.wait(1), "timeout")
	
	Global.gameManager.connect("onGameOver", self, "disablePausing")
	Global.gameManager.connect("onGameWon", self, "disablePausing")
	
func _input(event):
	if event is InputEventKey and event.pressed:
		match event.scancode:
			KEY_ESCAPE:
				var isPaused = get_tree().paused 
				emit_signal("pauseToggled", !isPaused)
				pause(!isPaused)

func pause(flag):
	get_tree().paused = flag
	emit_signal("onPause", flag)
	Global.enableCursor(flag)
	
func onTreeExiting():
	pause(false)
	
func disablePausing():
	set_process_input(false)
