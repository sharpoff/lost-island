extends Area2D

@export var up_layer_index: int
@export var down_layer_index: int
func _on_body_entered(body: CharacterBody2D) -> void:
	if body.global_position.x > global_position.x: # on the right
		_change_layer(body, down_layer_index, up_layer_index)
		body.z_index += 1
	if body.is_in_group("player"): # only works for player
		body.is_on_stairs = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): # only works for player
			body.is_on_stairs = false
	if body.global_position.x > global_position.x: # on the right
		_change_layer(body, up_layer_index, down_layer_index)
		body.z_index -= 1

func _change_layer(body: CharacterBody2D, from: int, to: int) -> void:
	#print_debug("Changed layer from ", from, ", to ", to)
	body.set_collision_mask_value(from, false)
	body.set_collision_mask_value(to, true)
