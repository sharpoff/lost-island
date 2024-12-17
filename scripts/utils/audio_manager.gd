extends Node

var playback: AudioStreamPlaybackPolyphonic

func _enter_tree() -> void:
	var player = AudioStreamPlayer.new()
	add_child(player)
	
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	
	playback = player.get_stream_playback()
	
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	if node is Button:
		node.button_up.connect(_play_button_up)

func _play_button_up() -> void:
	playback.play_stream(preload("res://assets/sounds/sfx/Click_UI_1.mp3"))
