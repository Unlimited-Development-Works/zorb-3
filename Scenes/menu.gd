extends Control

const COLORS = {
	"pink": Color(1, 0.243, 1, 0.482),
	"yellow": Color(1, 1, 0.243, 0.482),
	"green": Color(0.243, 1, 0.243, 0.482),
	"blue": Color(0.243, 1, 1, 0.482),
	"red": Color(1, 0, 0, 0.482),
}

var color_availability = {
	"pink": true,
	"yellow": true,
	"green": true,
	"blue": true,
	"red": true,
}

func take_available_color():
	for color_name in color_availability:
		if color_availability[color_name]:
			color_availability[color_name] = false
			return COLORS[color_name]
	return DeviceManager.COLOR_GREY

func _ready() -> void:
	for device in Input.get_connected_joypads():
		get_joypad_icon(device).visible = true
	Input.connect("joy_connection_changed", _on_joy_connection_changed)

func get_joypad_icon(device: int) -> TextureRect:
		return get_node("MenuList/JoypadList/Joypad%d" % device)

func _on_joy_connection_changed(device, connected):
	get_joypad_icon(device).visible = connected
	
func _process(delta) -> void:
	for device in Input.get_connected_joypads():
		if not DeviceManager.active_devices.has(device) and Input.is_joy_button_pressed(device, JOY_BUTTON_A):
			var color = take_available_color()
			DeviceManager.activate_device(device, color)
			get_joypad_icon(device).modulate = color
	var can_start_game = len(DeviceManager.active_devices) > 1	
	$MenuList/StartPrompt.modulate = Color.WHITE if can_start_game else Color.DIM_GRAY
	if can_start_game:
		for device in DeviceManager.active_devices:
			if Input.is_joy_button_pressed(device, JOY_BUTTON_START):
				GameManager.start_game(len(DeviceManager.active_devices))
