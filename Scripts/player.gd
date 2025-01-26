extends Node3D

func get_player_device() -> int:
	return %RigidBody3D.device.id
