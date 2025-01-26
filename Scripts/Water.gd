extends Node

func _on_body_entered(body:Node3D):
	# The faster you're going the higher you bounce
	if body is Bobby:
		var bounce_factor = clamp(body.linear_velocity.length(), 16, 40) / 8
		const BASE_BOUNCE_IMPULSE = 4
		body.apply_impulse(Vector3(0, BASE_BOUNCE_IMPULSE * bounce_factor, 0))
		body.splash()