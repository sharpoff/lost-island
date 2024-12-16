extends Node
# TODO: add UPnP setup for network discovery

signal player_connected(peer_id)
signal player_disconnected(peer_id)
signal server_disconnected

@export var player_scene: PackedScene
const PORT = 8000
const MAX_PLAYERS = 4
const DEFAULT_IP = "127.0.0.1"

var players_loaded = 0

var is_single_player = true

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected) # create player for all peers
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connection_ok)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func create_host():
	print_debug("Starting host")
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_PLAYERS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	player_connected.emit(multiplayer.get_unique_id())
	
func client_join(address: String = ""):
	print_debug("Starting client")
	if address.is_empty():
		address = DEFAULT_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

# every time player connects add it
func _on_player_connected(peer_id: int) -> void:
	print_debug("Player connected")
	emit_signal("player_connected", peer_id)

# every time player disconnects remove it
func _on_player_disconnected(peer_id: int) -> void:
	print_debug("Player disconnected")
	emit_signal("player_disconnected", peer_id)

func _on_connection_ok() -> void:
	print_debug("Connection success")

func _on_connection_failed() -> void:
	print_debug("Connection failed")
	_remove_multiplayer_peer()

func _on_server_disconnected() -> void:
	print_debug("Server disconnected")
	_remove_multiplayer_peer()

func _remove_multiplayer_peer() -> void:
	multiplayer.multiplayer_peer = null
