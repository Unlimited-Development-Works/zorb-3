extends Node

class_name DeviceManager

const DEVICE_COLORS = {
	-1: Color(0.243, 0.243, 0.243, 0.482),
	0: Color(1, 0.243, 1, 0.482),
	1: Color(1, 1, 0.243, 0.482),
	2: Color(0.243, 1, 0.243, 0.482),
	3: Color(0.243, 1, 1, 0.482),
}

func _ready():
	print('new device manager')

static var active_devices = []

static func is_device_available():
	var connected_devices = Input.get_connected_joypads()
	var available_devices = connected_devices.filter(
		func(c): return not active_devices.has(c))
	return len(available_devices) > 0

static func get_device():
	var connected_devices = Input.get_connected_joypads()
	var available_devices = connected_devices.filter(
		func(c): return not active_devices.has(c))
	
	# assert(len(available_devices) > 0, "Attempting to acquire a player without an available device")

	var id = available_devices[0] if len(available_devices) > 0 else -1
	active_devices.append(id)
	return {
		"id": id,
		"inputs": {
			"UP": "P%s_UP" % id,
			"DOWN": "P%s_DOWN" % id,
			"LEFT": "P%s_LEFT" % id,
			"RIGHT": "P%s_RIGHT" % id,
			"BOOST": "P%s_BOOST" % id,
			"JUMP": "P%s_JUMP" % id,
		},
		"color": DEVICE_COLORS[id], 
	}
