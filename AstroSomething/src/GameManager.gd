extends Spatial
class_name GameManager

onready var aabb = $LevelBounds
onready var rootNode = get_node("/root")

signal onGameWon
signal onGameOver

var gameOver = false
var assteroids = []

func _ready():
	Global.gameManager = self
	Global.enableCursor(false)
	
	set_physics_process(false)
	yield(Global.wait(1), "timeout")
	set_physics_process(true)
	
	connect("onGameOver", self, "gameOver")
	findAllAssteroids()
	
func findAllAssteroids():
	for child in get_children():
		var body = child.get_node("Body")
		if(body!=null && body is Assteroid):
			assteroids.append(body)
			body.connect("onExplode", self, "onAssteroidExploded")
			
func _physics_process(delta):
	if(!gameOver && !testPlayerBounds()):
		gameOver = true
		emit_signal("onGameOver")
	
func testPlayerBounds():
	var playerBounds = AABB(Global.player.global_transform.origin, Vector3.ONE)
	var intersects: bool = aabb.get_transformed_aabb().intersects(playerBounds)
#	print("intersects %s"%intersects)
	return intersects

func onAssteroidExploded(assteroid):
	var index = assteroids.find(assteroid)
	
	if(index >= 0):
		assteroids.remove(index)
		
	if(assteroids.size() <= 0):
		checkGameWon()
		
func checkGameWon():
	print("checkGameWon")
	
	if(Global.player.is_safe()):
		print("immediate win -> player is safe")
		gameWon()
	else:
		print("win wait until player is safe")
		
		while(!Global.player.is_safe()):
			yield(Global.wait(0.1), "timeout")
			print("wait until player is safe tick")
		gameWon()

func gameOver():
	yield(Global.wait(1), "timeout")
	Global.retryGame()

func gameWon():
	Global.player.disconnect("got_safe", self, "gameWon")
	emit_signal("onGameWon")
	print("Game Won")
	yield(Global.wait(2), "timeout")
	Global.retryGame()
