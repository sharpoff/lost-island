extends Node2D

@export var player_scene: PackedScene
@export var island_map: PackedScene
@onready var inventory_interface: Control = $UI/InventoryInterface
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

func player_disconnected(peer_id):
	if not players_node.has_node(str(peer_id)):
		return
	players_node.get_node(str(peer_id)).queue_free()

@rpc("call_local")
func load_world():
	var map = island_map.instantiate()
	world_node.add_child(map)

	var spawn_position = Vector2()
	
	if map.has_node("SpawnPoint"):
		spawn_position = map.get_node("SpawnPoint").global_position

	for peer in GameManager.players:
		var player = player_scene.instantiate() as Player
		player.name = str(peer)
		player.global_position = spawn_position
		players_node.add_child(player)
		
		if player.inventory:
			inventory_interface.set_inventory_data(player.inventory)
		if player.hotbar:
			inventory_interface.set_hotbar_data(player.hotbar)
	
	SignalBus.emit_signal("set_current_player", players_node.get_node(str(multiplayer.get_unique_id())))

	# TODO: move it somewhere
	GameManager.current_map = map
	
	var tween = get_tree().create_tween()
	tween.tween_property($Fade/TextureRect, "modulate", Color(1, 1, 1, 0), 2)
	tween.tween_callback($Fade.queue_free)

func server_disconnected():
	GameManager.change_scene("res://scenes/ui/menu_main.tscn")
