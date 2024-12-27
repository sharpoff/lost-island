extends Node2D

@export var player_scene: PackedScene
@export var island_map_scene: PackedScene
@export var house_map_scene: PackedScene
@onready var world_node: Node2D = $World
@onready var players_node: Node2D = $Players

func _ready() -> void:
	GameManager.game_started.connect(start_game)
	GameManager.player_disconnected.connect(player_disconnected)
	GameManager.server_disconnected.connect(server_disconnected)
	GameManager.player_loaded.rpc_id(1) # Tell the server that this peer has loaded.

func start_game() -> void:
	if !multiplayer.is_server():
		return

	load_world.rpc()

	SaveManager.load_game()

func player_disconnected(peer_id):
	if not players_node.has_node(str(peer_id)):
		return
	players_node.get_node(str(peer_id)).queue_free()

@rpc("call_local")
func load_world():
	$Fade.show()

	var island_map = island_map_scene.instantiate()
	world_node.add_child(island_map)
	
	# TODO: move it somewhere
	GameManager.current_map = island_map

	var spawn_position = Vector2()
	
	if GameManager.current_map.has_node("SpawnPoint"):
		spawn_position = GameManager.current_map.get_node("SpawnPoint").global_position

	for peer in GameManager.players:
		var player = player_scene.instantiate() as Player
		player.name = str(peer)
		player.global_position = spawn_position
		players_node.add_child(player)

		if player.inventory:
			SignalBus.emit_signal("set_inventory_data", player.inventory)
		if player.hotbar:
			SignalBus.emit_signal("set_hotbar_data", player.hotbar)

	SignalBus.emit_signal("set_current_player", players_node.get_node(str(multiplayer.get_unique_id())))

	var tween = get_tree().create_tween()
	tween.tween_property($Fade/TextureRect, "modulate", Color(1, 1, 1, 0), 2)
	tween.tween_callback($Fade.queue_free)

@rpc("any_peer")
func change_map(name: String) -> void:
	var spawn_pos: Vector2 = Vector2()
	var map
	match name.to_lower():
		"house":
			map = house_map_scene.instantiate()
			world_node.remove_child(GameManager.current_map)
			GameManager.current_map = map
			world_node.add_child(GameManager.current_map)
			spawn_pos = GameManager.current_map.get_node("SpawnPoint").position
			GameManager.current_player.position = spawn_pos
		"island":
			map = island_map_scene.instantiate()
			world_node.remove_child(GameManager.current_map)
			GameManager.current_map = map
			world_node.add_child(GameManager.current_map)
			spawn_pos = GameManager.current_map.get_node("DoorPoint").position
			GameManager.current_player.position = spawn_pos

func server_disconnected():
	GameManager.change_scene("res://scenes/ui/menu_main.tscn")
