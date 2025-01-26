extends Node3D

func set_color(color: Color):
	color.a = 1
	$Sprite3D.modulate = color

func activate(direction: Vector2, strength: float):
	show()
	set_global_rotation(Vector3(0, -direction.angle(), 0))
	$Sprite3D.position.x = strength * 1.9
	
func deactivate():
	hide()

func _physics_process(delta: float) -> void:
	global_position = %RigidBody3D.global_position
