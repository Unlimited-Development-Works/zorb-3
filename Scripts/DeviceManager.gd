class_name DeviceManager

const COLOR_GREY = Color(0.243, 0.243, 0.243, 0.482)

static var device_colors = {
	-1: COLOR_GREY,
	0: COLOR_GREY,
	1: COLOR_GREY,
	2: COLOR_GREY,
	3: COLOR_GREY,
	4: COLOR_GREY,
}

static var active_devices = []

static func activate_device(device: int, color: Color):
	device_colors[device] = color
	active_devices.append(device)

static var assigned_devices = []

static func reset():
	for device in device_colors:
		device_colors[device] = COLOR_GREY
	active_devices.clear()
	assigned_devices.clear()

static func get_device():
	var available_devices = active_devices.filter(
		func(device): return not assigned_devices.has(device)
	)
	
	if len(available_devices) == 0:
		return null

	var device = available_devices[0]
	assigned_devices.append(device)
	return {
		"id": device,
		"inputs": {
			"UP": "P%s_UP" % device,
			"DOWN": "P%s_DOWN" % device,
			"LEFT": "P%s_LEFT" % device,
			"RIGHT": "P%s_RIGHT" % device,
			"BOOST": "P%s_BOOST" % device,
			"JUMP": "P%s_JUMP" % device,
		},
		"color": device_colors[device], 
	}
	
