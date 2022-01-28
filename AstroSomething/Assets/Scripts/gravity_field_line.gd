extends GravityField

export var gravity_line:Vector3 = Vector3.UP

func get_direction(position:Vector3) -> Vector3:
	var line = gravity_line
	if !get_is_direction_using_internal_rotation():
		line = transform.basis.orthonormalized().xform_inv(line)
	
	var direction:Vector3 = line.cross(global_transform.origin - position).normalized()
	return direction.rotated(line, PI/2)


export var acceleration:float = 0
func get_acceleration(squared_distance:float) -> float: return acceleration

export var is_direction_using_internal_rotation: = false
func get_is_direction_using_internal_rotation() -> bool: return is_direction_using_internal_rotation

func apply_acceleration_to_kinematic_character(kinect_character:KinematicCharacter):
	var line = gravity_line
	if !get_is_direction_using_internal_rotation():
		line = transform.basis.orthonormalized().xform_inv(line)
	
	var direction:Vector3 = get_direction(kinect_character.global_transform.origin)
	kinect_character.additional_gravitational_impulse -= acceleration * direction
