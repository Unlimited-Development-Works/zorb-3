extends RigidBody3D


func _physics_process(delta: float) -> void:
    const FORCE_Z = 0.05 # need to angle the force toward the sphere
    const FORCE_MAGNITUDE = 10 # used to adjust magnitude of force
    var radius = $CollisionShape3D.shape.get_radius();
    var direction = Input.get_vector("P0_LEFT", "P0_RIGHT", "P0_UP", "P0_DOWN").limit_length(1)
    var force_vector = Vector3(direction.x, -direction.y, FORCE_Z) * FORCE_MAGNITUDE
    var force_position = Vector3(0, radius, radius)
    if (Input.is_action_pressed("P0_UP") 
        or Input.is_action_pressed("P0_DOWN") 
        or Input.is_action_pressed("P0_LEFT") 
        or Input.is_action_pressed("P0_RIGHT")):
        self.apply_force(force_vector, force_position)
