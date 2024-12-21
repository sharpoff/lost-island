extends Node2D

@export var player_scene: PackedScene

func _ready() -> void:
	# TODO: add multiplayer player creation
	add_child(player_scene.instantiate())
