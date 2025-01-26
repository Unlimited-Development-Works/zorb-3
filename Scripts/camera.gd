extends Camera3D

@export var movement_multiplier : float = 1
@export var duration : float = 40
@export var camera_start : Vector3
@export var camera_end : Vector3
@export var camera_start_rotation : float
@export var camera_end_rotation : float
var current_look_at = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transform.origin.y = camera_start.y
	transform.origin.z = camera_start.z
	current_look_at = camera_start_rotation
	look_at(Vector3(0, 0, current_look_at))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var difference = (camera_start.z - camera_end.z) / (camera_start.y - camera_end.y)
	if transform.origin.y > camera_end.y:
		transform.origin.y -= ((transform.origin.y - camera_end.y) / duration) * delta
	if transform.origin.z > camera_end.z:
		transform.origin.z -= ((transform.origin.z - camera_end.z) / duration) * delta
	if current_look_at > camera_end_rotation:
		current_look_at -= ((current_look_at - camera_end_rotation) / duration) * delta
	look_at(Vector3(0, 0, current_look_at))
