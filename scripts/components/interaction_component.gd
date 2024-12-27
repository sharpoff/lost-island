extends Area2D
class_name InteractionComponent

signal interacted

var interaction_body

func _process(_delta: float) -> void:
	if interaction_body and Input.is_action_just_pressed("interact"):
		interacted.emit(interaction_body)

func _on_body_entered(body: Node2D) -> void:
	interaction_body = body

func _on_body_exited(_body: Node2D) -> void:
	interaction_body = null
