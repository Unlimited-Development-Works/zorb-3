extends Node
var min_size = 10
var timer_started = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# print(delta)
	if $Area3D/CollisionShape3D/CSGTorus3D.inner_radius > min_size:
		$Area3D/CollisionShape3D/CSGTorus3D.inner_radius -= delta
		$Area3D/CollisionShape3D/CSGTorus3D.outer_radius = $Area3D/CollisionShape3D/CSGTorus3D.inner_radius + 30
	else:
		$Area3D/CollisionShape3D/CSGTorus3D.inner_radius = min_size
		$Area3D/CollisionShape3D/CSGTorus3D.outer_radius = $Area3D/CollisionShape3D/CSGTorus3D.inner_radius + 30
		if !timer_started:
			$Timer.start()
			timer_started = true
	


func _on_timer_timeout() -> void:
	min_size = 1
