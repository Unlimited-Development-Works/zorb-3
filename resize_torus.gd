extends Node
var min_size = 10
var timer_started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# print(delta)
	if %CSGTorus3D.inner_radius > min_size:
		%CSGTorus3D.inner_radius -= delta
		%CSGTorus3D.outer_radius = %CSGTorus3D.inner_radius + 30
	else:
		%CSGTorus3D.inner_radius = min_size
		%CSGTorus3D.outer_radius = %CSGTorus3D.inner_radius + 30
		if !timer_started:
			$Timer.start()
			timer_started = true



func _on_timer_timeout() -> void:
	min_size = 1


func _on_area_3d_2_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	print("exited body_rid")
	print(body)
	if body.has_method("dead_test"):
		body.dead_test()
	else:
		print("does not have method")
