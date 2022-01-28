extends GravityField

export var direction:Vector3 = Vector3.UP
func get_direction(position:Vector3) -> Vector3: return direction

export var acceleration:float = 0
func get_acceleration(squared_distance:float) -> float: return acceleration
