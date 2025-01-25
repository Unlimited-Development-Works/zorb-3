extends RigidBody3D

var device
var can_boost: bool = true

func get_mid_vector(v1, v2):
	return (v1 + v2)/2;

func _ready():
	device = DeviceManager.get_device()
	print(device.color, %SoftBody3D.get_surface_override_material(0).albedo_color, %SoftBody3D.get_surface_override_material(0))
	
	var material = %SoftBody3D.get_surface_override_material(0).duplicate()
	material.albedo_color = device.color
	%SoftBody3D.set_surface_override_material(0, material)

func _physics_process(_delta: float) -> void:
	const FORCE_MAGNITUDE = 10 # used to adjust magnitude of force
	var radius = %RigidBody3D/CollisionShape3D.shape.get_radius();
	var direction = Input.get_vector(device.inputs.LEFT, device.inputs.RIGHT, device.inputs.UP, device.inputs.DOWN).limit_length(1)
	var force_vector = Vector3(direction.x, 0, direction.y) * FORCE_MAGNITUDE
	var force_position = Vector3(0, radius, 0)
	%RigidBody3D.linear_damp = 0;
	if (can_boost and Input.is_action_just_pressed(device.inputs.BOOST)):
		can_boost = false
		$BoostTimer.start()
		%RigidBody3D.apply_central_impulse(Vector3(direction.x, 0, direction.y) * 40)
	if (Input.is_action_pressed(device.inputs.LEFT)
		or Input.is_action_pressed(device.inputs.RIGHT)
		or Input.is_action_pressed(device.inputs.UP)
		or Input.is_action_pressed(device.inputs.DOWN)):

		# Split force applied between "spinning" top force and central	
		%RigidBody3D.apply_force(force_vector * 0.8, force_position)
		%RigidBody3D.apply_central_force(force_vector * 0.2)

		# Calculate turning factor from angle between force applied and current linear velocity
		var turning_factor = %RigidBody3D.linear_velocity.angle_to(force_vector) / PI;

		# Add some minor linear damping while turning
		const DAMPING_VALUE = 0.5;
		%RigidBody3D.linear_damp = DAMPING_VALUE * turning_factor; 

		# Add counteracting force in the direction of the midpoint between the applied force
		# direction and the opposite of the current linear velocity
		%RigidBody3D.apply_central_force(get_mid_vector(%RigidBody3D.linear_velocity  * -1, force_vector) * 15 * turning_factor)

func dead_test() -> void:
	$"..".queue_free()


func _on_boost_timer_timeout() -> void:
	can_boost = true
