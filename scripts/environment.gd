extends Node2D

@export var player_scene: PackedScene


func _ready() -> void:
	add_child(player_scene.instantiate())

func _process(delta: float) -> void:
	pass
