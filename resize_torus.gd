extends Node
var min_size = 2
var timer_started = false
var ring_thickness = 2
var multiplier = 1
var shrink : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%deathRing.scale.x = %CSGTorus3D.inner_radius
	%deathRing.scale.z = %CSGTorus3D.inner_radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shrink:
		if %CSGTorus3D.inner_radius > min_size:
			%CSGTorus3D.inner_radius -= delta * multiplier
			%deathRing.scale.x = %CSGTorus3D.inner_radius
			%deathRing.scale.z = %CSGTorus3D.inner_radius
			%CSGTorus3D.outer_radius = %CSGTorus3D.inner_radius + ring_thickness
		else:
			%CSGTorus3D.inner_radius = min_size
			%CSGTorus3D.outer_radius = %CSGTorus3D.inner_radius + ring_thickness
			#if !timer_started:
				#$Timer.start()
				#timer_started = true



func _on_timer_timeout() -> void:
	#min_size = 1
	#multiplier = 0.2
	shrink = !shrink



func _on_area_3d_2_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("dead_test"):
		body.dead_test()
		%DeathNoise.play()
	else:
		print("does not have method")
