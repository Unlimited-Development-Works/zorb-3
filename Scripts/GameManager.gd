extends Node

var bobby_scene: PackedScene = preload("res://Scenes/bobby.tscn")
var player_count = null
var players: Array[Node]
var pregame: bool = true
var game_over: bool = false

var changing_scene: bool = false
var game_over_label: Label = null
var win_label: Label = null

func _ready() -> void:
	pass

func reset_game():
	pregame = true
	game_over = false
	DeviceManager.reset()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func generate_spawn_position(i, player_count):
	return Vector3(20, 0, 0).rotated(Vector3.UP, float(i) * 2.0 * PI / float(player_count))

func start_game(player_count: int):
	get_tree().change_scene_to_file("res://Scenes/test.tscn")
	changing_scene = true
	self.player_count = player_count

func _on_world_ready():
	init_game(player_count)

func init_game(player_count):
	var level = get_tree().root.get_node("/root/World")
	game_over_label = level.get_node("%GameOverLabel")
	win_label = level.get_node("%WinLabel")
	players.clear()
	for i in range(0, player_count):
		var bobby = bobby_scene.instantiate()
		bobby.global_position = generate_spawn_position(i, player_count)
		players.append(bobby)
		level.add_child(bobby)
	pregame = false

func _process(delta: float) -> void:
	if changing_scene:
		if get_tree().root.get_node("/root/World/%GameOverLabel") != null:
			changing_scene = false
			init_game(player_count)
	if not pregame and not game_over:
		var players_left = players.filter(func (node): return is_instance_valid(node))
		if len(players_left) == 1:
			win_label.show()
			win_label.text = "Player %d wins!" % players_left[0].get_player_device()
		if len(players_left) < 2:
			game_over_label.show()
			game_over = true
	if game_over:
		if DeviceManager.active_devices.any(func (device): return Input.is_joy_button_pressed(device, JOY_BUTTON_START)):
			GameManager.reset_game()
