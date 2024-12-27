extends Node2D

func _on_interaction_component_interacted(body) -> void:
	if body.is_in_group("player"):
		# HACK: remove this
		get_tree().root.get_node("Main").change_map("island")
