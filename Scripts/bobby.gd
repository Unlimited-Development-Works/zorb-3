extends RigidBody3D

var device

func _ready():
	device = DeviceManager.get_device()
	print(device.color, %SoftBody3D.get_surface_override_material(0).albedo_color, %SoftBody3D.get_surface_override_material(0))
	
	var material = %SoftBody3D.get_surface_override_material(0).duplicate()
	material.albedo_color = device.color
	%SoftBody3D.set_surface_override_material(0, material)

func _physics_process(delta: float) -> void:
	const FORCE_Z = 0.05 # need to angle the force toward the sphere
	const FORCE_MAGNITUDE = 10 # used to adjust magnitude of force
	var radius = %RigidBody3D/CollisionShape3D.shape.get_radius();
	var direction = Input.get_vector(device.inputs.LEFT, device.inputs.RIGHT, device.inputs.UP, device.inputs.DOWN).limit_length(1)
	var force_vector = Vector3(direction.x, -direction.y, FORCE_Z) * FORCE_MAGNITUDE
	var force_position = Vector3(0, radius, radius)
	if (Input.is_action_pressed(device.inputs.LEFT) 
		or Input.is_action_pressed(device.inputs.RIGHT) 
		or Input.is_action_pressed(device.inputs.UP) 
		or Input.is_action_pressed(device.inputs.DOWN)):
		%RigidBody3D.apply_force(force_vector, force_position)

func dead_test() -> void:
	$"..".queue_free()
