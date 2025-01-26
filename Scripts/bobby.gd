extends RigidBody3D
class_name Bobby

@export_range(1, 30) var jump_strength: float = 20
@export var ground_y: float = 0

var splash_emitter = preload("res://Scenes/splash_emitter.tscn")

var device
var can_boost: bool = true
var can_jump: bool = true
var previous_linear_velocity

func get_mid_vector(v1, v2):
	return (v1 + v2)/2;

func _ready():
	device = DeviceManager.get_device()
	if device == null:
		print("WARNING: Bobby found no device, freeing")
		queue_free()
		return
	print(device.color, %SoftBody3D.get_surface_override_material(0).albedo_color, %SoftBody3D.get_surface_override_material(0))
	
	var material = %SoftBody3D.get_surface_override_material(0).duplicate()
	material.albedo_color = device.color
	%SoftBody3D.set_surface_override_material(0, material)
	%Arrow.set_color(device.color)

func _physics_process(_delta: float) -> void:
	if device == null:
		return
	const FORCE_MAGNITUDE = 10 # used to adjust magnitude of force
	var grounded = global_position.y < ground_y
	var radius = %RigidBody3D/CollisionShape3D.shape.get_radius();
	var direction = Input.get_vector(device.inputs.LEFT, device.inputs.RIGHT, device.inputs.UP, device.inputs.DOWN).limit_length(1)
	var force_vector = Vector3(direction.x, 0, direction.y) * FORCE_MAGNITUDE
	var force_position = Vector3(0, radius, 0)
	%RigidBody3D.linear_damp = 0;
	if grounded and can_boost and Input.is_action_just_pressed(device.inputs.BOOST):
		can_boost = false
		$BoostTimer.start()
		%RigidBody3D.apply_central_impulse(Vector3(direction.x, 0, direction.y) * 40)
	if grounded and can_jump and Input.is_action_just_pressed(device.inputs.JUMP):
		can_jump = false
		$JumpTimer.start()
		%RigidBody3D.apply_central_impulse(Vector3.UP * jump_strength)
	if (Input.is_action_pressed(device.inputs.LEFT)
		or Input.is_action_pressed(device.inputs.RIGHT)
		or Input.is_action_pressed(device.inputs.UP)
		or Input.is_action_pressed(device.inputs.DOWN)):

		%Arrow.activate(direction.normalized(), direction.length())

		if grounded:
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
	else:
		%Arrow.deactivate()
	self.previous_linear_velocity = %RigidBody3D.linear_velocity
	
func dead_test() -> void:
	$"..".queue_free()

func _on_boost_timer_timeout() -> void:
	can_boost = true
	
func _on_jump_timer_timeout() -> void:
	can_jump = true

func _on_body_entered(body):
	if body is not Bobby:
		#print("Not a bobby")
		return;

	var self_pos = Vector3(%RigidBody3D.global_position.x, 0, %RigidBody3D.global_position.z)
	var body_pos = Vector3(body.global_position.x, 0, body.global_position.z)

	var self_to_body = (body_pos - self_pos).normalized()
	var body_to_self = self_to_body * -1

	var self_lv = Vector3(%RigidBody3D.previous_linear_velocity.x, 0, %RigidBody3D.previous_linear_velocity.z)
	var body_lv = Vector3(body.previous_linear_velocity.x, 0, body.previous_linear_velocity.z)

	var self_dot = abs(self_pos.dot(self_lv))
	var body_dot = abs(body_pos.dot(body_lv))

	var self_impact_value = self_lv.length() * self_dot
	var body_impact_value = body_lv.length() * body_dot

	#print("Self", self_pos, self_to_body, self_lv, ",", self_lv.length(), ",", self_dot, ",",self_impact_value)
	#print("Body", body_pos, body_to_self, body_lv, ",", body_lv.length(), ",", body_dot, ",", body_impact_value)

	if self_impact_value >= body_impact_value and body_impact_value > 0:
		# You're the winner, or the winning impact value is 0 or less in which case nothing happens 
		return

	# You've lost and you're getting knocked back

	# Todo apply force at point of collison rather than centrally
	const KNOCKBACK_MULTIPLIER = 6
	%RigidBody3D.apply_central_impulse(body_to_self * clamp(body_lv.length() * KNOCKBACK_MULTIPLIER, 0, 40))

func splash():
	var bobby = self.get_parent()
	# Only splash if you're going fast enough in the x-z plane OR going fast enough in the Y axis
	# (Do not splash when not moving)
	var lv = self.get_linear_velocity()
	const SPLASH_THRESHOLD = 8
	var splash_value = max(Vector3(lv.x, 0, lv.z).length(), lv.y)
	var can_splash = splash_value > SPLASH_THRESHOLD
	if (not can_splash):
		return
	var splash_emitter_inst = splash_emitter.instantiate()
	splash_emitter_inst.amount = int(splash_value * 1.5) - SPLASH_THRESHOLD
	bobby.add_child(splash_emitter_inst)
	splash_emitter_inst.set_global_position(%RigidBody3D.get_global_position())
