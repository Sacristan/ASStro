extends Area

export var push_velocity:float = 40
onready var audio = $Sound 

func _ready():
	pass

func _process(delta):
	var up_direction = transform.basis.orthonormalized().xform(Vector3.UP)
	for body in get_overlapping_bodies():
		if body is KinematicCharacter:
			body.start_falling()
			body.velocity -= body.velocity.project(up_direction)
			body.velocity += up_direction*push_velocity
			audio.play()
