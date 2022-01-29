extends Spatial
class_name GameManager

onready var aabb = $LevelBounds

signal onGameOver
var gameOver = false

func _ready():
	set_physics_process(false)
	yield(Global.wait(1), "timeout")
	set_physics_process(true)
	
func _physics_process(delta):
	if(!gameOver && !testPlayerBounds()):
		gameOver = true
		emit_signal("onGameOver")
		yield(Global.wait(1), "timeout")
		retryGame()
	
func testPlayerBounds():
	var playerBounds = AABB(Global.player.global_transform.origin, Vector3.ONE)
	var intersects: bool = aabb.get_transformed_aabb().intersects(playerBounds)
#	print("intersects %s"%intersects)
	return intersects

func retryGame():
	get_tree().reload_current_scene()
