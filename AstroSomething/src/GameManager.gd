extends Spatial
class_name GameManager

onready var aabb = $LevelBounds

func _ready():
	set_physics_process(false)
	yield(Global.wait(1), "timeout")
	set_physics_process(true)
	
func _physics_process(delta):
	if(!testPlayerBounds()):
		print("out of bounds")
	
func testPlayerBounds():
	var playerBounds = AABB(Global.player.global_transform.origin, Vector3.ONE)
	var intersects: bool = aabb.get_transformed_aabb().intersects(playerBounds)
#	print("intersects %s"%intersects)
	return intersects
