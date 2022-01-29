extends Control

export(Array, Texture) var gasTextures;

#onready var healthLabel = $upperbar/Health/HealthLabel
#onready var waveLabel = $upperbar/Wave/WaveLabel
#onready var scoreLabel = $upperbar/Score/ScoreLabel
#
onready var gameOverPanel = $gameOver

onready var gameOverLostContainer = $gameOver/lost
onready var retryButtonGameOver = $gameOver/lost/retryButton
onready var menuButtonGameOver = $gameOver/lost/menuButton
onready var quitButtonGameOver = $gameOver/lost/quitButton

onready var gameOverVictoryContainer = $gameOver/victory
onready var nextButtonGameWin = $gameOver/victory/nextButton
onready var retryButtonGameWin = $gameOver/victory/retryButton
onready var menuButtonGameWin = $gameOver/victory/menuButton

onready var pauseMenu = $pauseMenu
onready var menuButtonPause = $pauseMenu/VBoxContainer/menuButton
onready var quitButtonPause = $pauseMenu/VBoxContainer/quitButton

onready var gasProgress = $GasBar/VBoxContainer/TextureProgress
onready var gasTexture = $GasBar/VBoxContainer/EmojiTexture

onready var damageEffect = $damageEffect

onready var player = Global.player
onready var gameManager = Global.gameManager

const DamageIndicationAppearTime = 0.25
const DamageIndicationDissapearTime = 3
var lastTimeDamageReceived = 0
var appearTimer = 0

func _ready():
	pauseMenu.visible = false
	gameOverPanel.visible = false
	set_process(false)
	
	yield(Global.wait(1), "timeout")
	set_process(true)
	
	Global.player.connect("onHealthChanged", self, "updateGasbar")
	Global.player.connect("onDamageReceived", self, "onReceivedDamage")
	
#	updateHealth(player.health)
#	player.connect("onHealthChanged", self, "_playerHealthChanged")
#	player.connect("onReceivedDamage", self, "onReceivedDamage")
#
#	gameManager.connect("onWaveSpawned", self, "updateWave")
#	gameManager.connect("onScoreChanged", self, "updateScore")

	Global.gameManager.connect("onGameOver", self, "onGameOver")
	Global.gameManager.connect("onGameWon", self, "onGameWon")
	
	nextButtonGameWin.connect("pressed", Global, "nextLevel")
	
	retryButtonGameOver.connect("pressed", Global, "retryGame")
	retryButtonGameWin.connect("pressed", Global, "retryGame")
#
	menuButtonGameOver.connect("pressed", Global, "launchMenu")
	menuButtonGameWin.connect("pressed", Global, "launchMenu")
	
	quitButtonGameOver.connect("pressed", Global, "quitGame")
	
	menuButtonPause.connect("pressed", Global, "launchMenu")
	quitButtonPause.connect("pressed", Global, "quitGame")
#
	Global.stateManager.connect("onPause", self, "onPauseToggled")
	
	set_process(false)
	update_damage_alpha(0)

func _process(delta):
	var timeDelta = Global.gameManager.currentTime - lastTimeDamageReceived
	var t
	var alpha = 0
	
	updateGasbar(timeDelta)
	
	if timeDelta < DamageIndicationAppearTime:
		appearTimer+=delta
		t = appearTimer / DamageIndicationAppearTime
		alpha = lerp(get_damage_alpha(), 0.5, t)
		update_damage_alpha(alpha)
		
	elif timeDelta < DamageIndicationDissapearTime:
		t = timeDelta / (DamageIndicationDissapearTime - DamageIndicationAppearTime)
		alpha = lerp(get_damage_alpha(), 0, t)
		update_damage_alpha(alpha)
				
func update_damage_alpha(alpha):
	damageEffect.material.set_shader_param("Alpha", alpha)
	
func get_damage_alpha():
	return damageEffect.material.get_shader_param("Alpha")
	
func onReceivedDamage():
	lastTimeDamageReceived = gameManager.currentTime
	set_process(true)
	appearTimer = 0

#func updateHealth(health):
#	healthLabel.text = "Health: %d"%round(health)
#
#func updateWave(waveId):
#	waveLabel.text = "Wave: %s"%waveId
#
#func updateScore(score):
#	scoreLabel.text = "Score: %d"%score
#
func updateGasbar(gas):
	gasProgress.value = lerp(0, 100, gas)
	gasTexture.texture = getGasTex(gas);
#
func getGasTex(gas):
	if(gas > 0.8):
		return gasTextures[0];
	elif(gas < 0.8 && gas > 0.6):
		return gasTextures[1];	
	elif(gas < 0.6 && gas > 0.4):
		return gasTextures[2];	
	elif(gas < 0.4 && gas > 0.2):
		return gasTextures[3];	
	elif(gas < 0.2 && gas > 0.01):
		return gasTextures[4]
	elif(gas < 0.01):
		return gasTextures[5];	
		
		
func onGameWon():
	gameOverBase()
	gameOverVictoryContainer.show()
	gameOverLostContainer.hide()
	
func onGameOver():
	gameOverBase()
	gameOverVictoryContainer.hide()
	gameOverLostContainer.show()
	
func gameOverBase():
	Global.stateManager.disconnect("onPause", self, "onPauseToggled")
	
#	healthLabel.hide()
#	waveLabel.hide()
#	scoreLabel.hide()
	gasProgress.hide()
	gasTexture.hide()
	gameOverPanel.show()
	
	Global.stateManager.pause(true)
	
func onPauseToggled(isPause):
	if(isPause):
		pauseMenu.show()
	else:
		pauseMenu.hide()