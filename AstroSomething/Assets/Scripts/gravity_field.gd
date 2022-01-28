extends Area
class_name GravityField

func get_direction(position:Vector3) -> Vector3: return Vector3.UP
func get_is_direction_using_internal_rotation() -> bool: return true
func get_acceleration(squared_distance:float) -> float: return 9.8


func _ready():
	connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	apply_acceleration_to_overlapping_bodies()

func _on_body_entered(body):
	if body is KinematicCharacter:
		body.end_jumping()

func apply_acceleration_to_kinematic_character(kinect_character:KinematicCharacter):
	var kinect_character_position:Vector3 = kinect_character.global_transform.origin
	if get_is_direction_using_internal_rotation():
		kinect_character_position = to_local(kinect_character_position)
	else:
		kinect_character_position -= global_transform.origin
	
	var acceleration = get_acceleration(kinect_character_position.length_squared())
	var direction:Vector3 = get_direction(kinect_character_position)
	
	kinect_character.additional_gravitational_impulse += direction * acceleration

func apply_acceleration_to_overlapping_bodies() -> void:
	for physics_body in get_overlapping_bodies():
		if physics_body is KinematicCharacter:
			apply_acceleration_to_kinematic_character(physics_body)
