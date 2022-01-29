extends KinematicCharacterWithExportedAttributes


var _request_attack: = false

export var attack_command:String = "attack"
export var move_forward_command:String = "move_forward"
export var move_back_command:String = "move_back"
export var move_right_command:String = "move_right"
export var move_left_command:String = "move_left"
export var jump_command:String = "jump"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	_update_camera_rotation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_update_horizontal_physics_rotation_update_type()
	_update_animation_tree()
	_update_floor_normal()
	_update_movement_input()

func _input(event):
	if event.is_action(attack_command):
		if Input.is_action_just_pressed(attack_command):
			_request_attack = true
	elif event.is_action(self.jump_command):
		_check_jump()


func _check_jump() -> void:
	if Input.is_action_just_released(self.jump_command) or (self.stop_jumping_on_ceiling and .is_on_ceiling()):
		.end_jumping()
	elif Input.is_action_just_pressed(self.jump_command):
		.start_jumping()

func _update_movement_input() -> void:
	self.movement_input = (Vector2.UP * Input.get_action_strength(move_forward_command)) + (Vector2.DOWN * Input.get_action_strength(move_back_command)) + (Vector2.RIGHT * Input.get_action_strength(move_right_command)) + (Vector2.LEFT * Input.get_action_strength(move_left_command))
	
	self._is_applying_move_input = self.movement_input.length_squared() >= pow(self.minimal_movement_input, 2)
	if !self._is_applying_move_input:
		self.movement_input = Vector2.ZERO

func _update_camera_rotation() -> void:
	$CameraPivot.global_transform.basis = Basis(.view_rotation())

func _update_horizontal_physics_rotation_update_type():
	if .is_on_floor() and .is_braking() and get_control_movement_input() != Vector3.ZERO:
		horizontal_physics_rotation_update_type = HorizontalPhysicsRotationUpdateType.NO_UPDATE
	else:
		horizontal_physics_rotation_update_type = HorizontalPhysicsRotationUpdateType.CONTROL_INPUT

func _update_animation_tree():
	$AnimationTree.vertical_direction = _vertical_direction
	$AnimationTree.velocity = velocity
	$AnimationTree.is_on_floor = is_on_floor()
	$AnimationTree.is_attached_to_a_wall = is_attached_to_a_wall()
	$AnimationTree.is_braking = is_braking() and _control_movement_input != Vector3.ZERO
	if _request_attack:
		$AnimationTree.request_attack()
	_request_attack = false

func _update_floor_normal():
	var speed = velocity.length()
	if is_on_floor() and speed > on_floor_control_speed/2:
		floor_normal_type = FloorNormalType.CURRENT_FLOOR_IMPACT_NORMAL
	else:
		floor_normal_type = FloorNormalType.GRAVITY_IMPULSE
