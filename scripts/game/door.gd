extends Node2D

@export_file var scene_path: String

func _on_interaction_component_interacted(body) -> void:
	if body.is_in_group("player"):
		print_debug("enter door")
