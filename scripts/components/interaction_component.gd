extends Area2D

signal interacted

var interaction_body

func _process(delta: float) -> void:
	if interaction_body and Input.is_action_just_pressed("interact"):
		print_debug("interact")
		interacted.emit(interaction_body)

func _on_body_entered(body: Node2D) -> void:
	interaction_body = body


func _on_body_exited(body: Node2D) -> void:
	interaction_body = null
