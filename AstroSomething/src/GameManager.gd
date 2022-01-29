extends Spatial
class_name GameManager

onready var aabb = $LevelBounds

signal onGameOver
var gameOver = false

func _ready():
	Global.gameManager = self
	
	Global.enableCursor(false)
	
	set_physics_process(false)
	yield(Global.wait(1), "timeout")
	set_physics_process(true)
	
	connect("onGameOver", self, "gameOver")
	
func _physics_process(delta):
	if(!gameOver && !testPlayerBounds()):
		gameOver = true
		emit_signal("onGameOver")
	
func testPlayerBounds():
	var playerBounds = AABB(Global.player.global_transform.origin, Vector3.ONE)
	var intersects: bool = aabb.get_transformed_aabb().intersects(playerBounds)
#	print("intersects %s"%intersects)
	return intersects

func gameOver():
	yield(Global.wait(1), "timeout")
	Global.retryGame()
