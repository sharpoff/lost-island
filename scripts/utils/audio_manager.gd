extends Node2D

var master_playback: AudioStreamPlaybackPolyphonic
var stream = AudioStreamPolyphonic.new()
	
func _enter_tree() -> void:
	var master_player = AudioStreamPlayer.new()
	add_child(master_player)
	
	stream.polyphony = 32
	
	master_player.stream = stream
	master_player.bus = "Master"
	master_player.play()
	master_playback = master_player.get_stream_playback()
	
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	if node is Button:
		node.button_up.connect(_play_button_up)

func _play_button_up() -> void:
	master_playback.play_stream(preload("res://assets/sounds/sfx/Click_UI_1.mp3"))
