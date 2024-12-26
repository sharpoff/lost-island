extends Node2D

@export var map_name: String

func _on_interaction_component_interacted(body) -> void:
	if body.is_in_group("player"):
		GameManager.change_map(map_name)
