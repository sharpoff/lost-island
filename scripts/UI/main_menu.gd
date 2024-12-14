# holds all map related functionality
extends Control

@export var player_scene: PackedScene
@onready var IP_ADDR = $VBoxContainer2/VBoxContainer/IPAddress.text
@export var PORT = 8888
@export var MAX_PLAYERS = 4
@onready var environment: Node2D = $"../Environment"

var enet_peer = ENetMultiplayerPeer.new()

func _on_host_pressed() -> void:
	print_debug("Starting host")
	enet_peer.create_server(PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player) # for other players
	add_player(multiplayer.get_unique_id()) # for host to player
	
	# hide menu, show environment
	hide()
	environment.show()

# every time player connects it adds it
func add_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	environment.call_deferred("add_child", player)

func _on_join_pressed() -> void:
	print_debug("Starting client")
	if not IP_ADDR:
		print_debug("IP_ADDR is null, enter your ip")
		# show error message
		return
	enet_peer.create_client(IP_ADDR, PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	# hide menu, show environment
	hide()
	environment.show()

func _on_quit_pressed() -> void:
	print_debug("quit_pressed")
	get_tree().quit()
