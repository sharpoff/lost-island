extends Area2D

@export var scene_to_transit: String

func _on_body_entered(body: Node2D) -> void:
	print_debug("Entered")
	if body.is_in_group("player"):
		pass
		#get_tree().change_scene_to_file(scene_to_transit) # redundant
