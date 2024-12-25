extends Node2D

@export var player_scene: PackedScene
@export var island_map: PackedScene
@onready var inventory_interface: Control = $UI/InventoryInterface

var spawn_position = Vector2(-720, -59)

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
		var player = player_scene.instantiate() as Player
		player.name = str(peer)
		player.global_position = spawn_position
		$Players.add_child(player)
		
		if player.inventory:
			inventory_interface.set_inventory_data(player.inventory)
		if player.hotbar:
			inventory_interface.set_hotbar_data(player.hotbar)

	var map = island_map.instantiate()
	$World.add_child(map)

	# TODO: move it somewhere
	GameManager.current_map = map.get_node("AboveGround")

func server_disconnected():
	GameManager.change_scene.rpc("res://scenes/ui/menu_main.tscn")
