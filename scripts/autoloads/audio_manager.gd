extends Node

@export var button_click_sound: AudioStreamPlayer
@export var background_music: AudioStreamPlayer

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	if node is Button:
		node.button_up.connect(_play_button_up)

func _play_button_up() -> void:
	button_click_sound.play()

func change_bus_db(bus_name: String, db: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, db)
