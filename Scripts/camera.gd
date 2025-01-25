extends Camera3D

var zoom_min = 10
var zoom_max = 100
var movement_multiplier = 10
var yz_multiplier = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transform.origin.y = zoom_max * yz_multiplier
	transform.origin.z = zoom_max
	look_at(Vector3(0, 0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if transform.origin.y > zoom_min or transform.origin.z > zoom_min:
		transform.origin.y -=  (delta * yz_multiplier) * movement_multiplier
		transform.origin.z -= delta * movement_multiplier
