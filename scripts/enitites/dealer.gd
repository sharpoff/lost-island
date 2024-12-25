extends Node
class_name Dealer


func _on_interaction_component_interacted(body) -> void:
	if body.is_in_group("Player"):
		print_debug("player interacted")
