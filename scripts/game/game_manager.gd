extends Node
# TODO: add UPnP setup for network discovery

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected
signal game_started
signal net_error(what)

@export var player_scene: PackedScene
const PORT = 8000
const MAX_PLAYERS = 4
const DEFAULT_IP = "127.0.0.1"

# all players infos with keys being each players's unique IDs
var players = {}
var players_loaded = 0

# local player info
var player_info = {"name": "Chill guy"}

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connection_ok) # emitted only on clients
	multiplayer.connection_failed.connect(_on_connection_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected) # emitted only on clients

func create_game():
	print_debug("Starting host")
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_PLAYERS)
	if error:
		net_error.emit(error)
		return error
	multiplayer.multiplayer_peer = peer
	# register server
	players[multiplayer.get_unique_id()] = player_info
	player_connected.emit(multiplayer.get_unique_id(), player_info)
	print_debug("Host started")

func join_game(address: String = ""):
	print_debug("Starting client")
	if address.is_empty():
		address = DEFAULT_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error != OK:
		print_debug(error)
		return error
	multiplayer.multiplayer_peer = peer
	print_debug("Client started")

@rpc("call_local", "reliable")
func change_scene(scene_path: String) -> void:
	print_debug("Changing scene to %s" % scene_path)
	get_tree().change_scene_to_file(scene_path)

# evry peer call this when they loaded and server will keep track of all players
# and run game when everyone loaded
@rpc("any_peer", "call_local", "reliable")
func player_loaded() -> void:
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			game_started.emit()
			players_loaded = 0

# every time player connects register him and send it's player_info to other peers
func _on_player_connected(peer_id: int) -> void:
	print_debug("Player with id %s connected" % peer_id)
	_register_player.rpc_id(peer_id, player_info)

@rpc("any_peer", "reliable")
func _register_player(info: Dictionary) -> void:
	var sender_id = multiplayer.get_remote_sender_id()
	players[sender_id] = info
	player_connected.emit(sender_id, info)

# every time player disconnects remove it
func _on_player_disconnected(peer_id: int) -> void:
	print_debug("Player with id %s disconnected" % peer_id)
	players.erase(peer_id)
	player_disconnected.emit(peer_id)

 # successfully connected to server
func _on_connection_ok() -> void:
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)

func _on_connection_fail() -> void:
	print_debug("Connection failed")
	_disconnect()

func _on_server_disconnected() -> void:
	print_debug("Server disconnected")
	_disconnect()
	server_disconnected.emit()

func _disconnect() -> void:
	multiplayer.multiplayer_peer = null
	players.clear()
