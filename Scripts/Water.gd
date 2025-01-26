extends Node

func _on_body_entered(body:Node3D):
	# The faster you're going the higher you bounce
	if body is Bobby:
		var lv = body.get_linear_velocity()
		var non_y_len = Vector3(lv.x, 0, lv.z).length();
		const BOUNCE_THRESHOLD = 4
		if (non_y_len < BOUNCE_THRESHOLD):
			return
		var bounce_factor = clamp(body.linear_velocity.length(), 16, 40) / 8
		const BASE_BOUNCE_IMPULSE = 4
		body.apply_impulse(Vector3(0, BASE_BOUNCE_IMPULSE * bounce_factor, 0))
		body.splash()
