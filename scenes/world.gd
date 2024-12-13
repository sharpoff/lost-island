extends Node

@export var player_scene: PackedScene
@export var IP_ADDR = "localhost"
@export var PORT = 8888
@export var MAX_PLAYERS = 4

var enet_peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	$MainMenu.host_button_pressed.connect(create_host)
	$MainMenu.join_button_pressed.connect(create_client)


func create_host() -> void:
	print_debug("Starting host")
	enet_peer.create_server(PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player) # for other players
	add_player(multiplayer.get_unique_id()) # for host to player
	
	# hide menu, show environment
	$MainMenu.hide()
	$Environment.show()

func create_client() -> void:
	print_debug("Starting client")
	enet_peer.create_client(IP_ADDR, PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	# hide menu, show environment
	$MainMenu.hide()
	$Environment.show()

# every time player connects it adds it
func add_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
