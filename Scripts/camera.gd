extends Camera3D

var movement_multiplier = 1
@export var camera_start : Vector3
@export var camera_end : Vector3 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transform.origin.y = camera_start.y
	transform.origin.z = camera_start.z
	look_at(Vector3(0, 0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(Vector3(0, 0, 0))
	var difference = (camera_start.z - camera_end.z) / (camera_start.y - camera_end.y)
	if transform.origin.y > camera_end.y:
		transform.origin.y -= (delta * movement_multiplier) * difference
	if transform.origin.z > camera_end.y:
		transform.origin.z -= (delta * movement_multiplier)

