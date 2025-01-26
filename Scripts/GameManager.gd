extends Node

var bobby_scene: PackedScene = preload("res://Scenes/bobby.tscn")
var players: Array[Node]
var pregame: bool = true
var game_over: bool = false

func _ready() -> void:
	pass

func reset_game():
	DeviceManager.reset()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func generate_spawn_position(i, player_count):
	return Vector3(20, 0, 0).rotated(Vector3.UP, float(i) * 2.0 * PI / float(player_count))

func start_game(player_count: int):
	get_tree().change_scene_to_file("res://Scenes/test.tscn")
	var spawn_parent = get_tree().root.get_child(0)
	for i in range(0, player_count):
		var bobby = bobby_scene.instantiate()
		bobby.global_position = generate_spawn_position(i, player_count)
		spawn_parent.add_child(bobby)

func _process(delta: float) -> void:
	#if not game_over:
		#var players_left = players.reduce(func (count, node): return count + 1 if is_instance_valid(node) else count, 0)
		#if players_left == 1:
			#print('Win')
		#if players_left == 0:
			#print('Game over')
		#if players_left < 2:
			#%GameOverLabel.show()
			#game_over = true
	pass
