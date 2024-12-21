extends Node2D

@export var player_scene: PackedScene
@export var island_map: PackedScene

func _ready() -> void:
	GameManager.game_started.connect(start_game)
	GameManager.player_disconnected.connect(player_disconnected)
	GameManager.server_disconnected.connect(server_disconnected)
	GameManager.player_loaded.rpc_id(1) # Tell the server that this peer has loaded.

func start_game() -> void:
	if !multiplayer.is_server():
		return

	load_world.rpc()

func player_disconnected(peer_id):
	if not $Players.has_node(str(peer_id)):
		return
	$Players.get_node(str(peer_id)).queue_free()

@rpc("call_local")
func load_world():
	for peer in GameManager.players:
		var player = player_scene.instantiate()
		player.name = str(peer)
		$Players.add_child(player)

	$World.add_child(island_map.instantiate())

func server_disconnected():
	GameManager.change_scene("res://scenes/ui/menu_main.tscn")
