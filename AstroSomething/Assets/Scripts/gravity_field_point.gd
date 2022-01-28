extends GravityField

export var center:Vector3 = Vector3.ZERO

export var acceleration:float = 0
func get_acceleration(squared_distance:float) -> float: return acceleration

func get_direction(position:Vector3) -> Vector3: 
	return (center - position).normalized()
