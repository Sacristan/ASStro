extends WorldEnvironment

func _ready():
	match(OS.get_name()):
		"HTML5":
			var env = get_environment()
			env.ssao_enabled = false
			env.dof_blur_far_enabled = false
