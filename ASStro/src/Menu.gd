extends Control

onready var playButton = $Control/VBoxContainer/Play
onready var quitButton = $Control/VBoxContainer/Quit

func _ready():
	Global.enableCursor(true)
	playButton.connect("pressed", Global, "launchGame")
	quitButton.connect("pressed", Global, "quitGame")
