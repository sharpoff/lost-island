# holds all map related functionality
extends Control
class_name MainMenu

@export var singleplayer_scene: PackedScene
@export var lobby_scene: PackedScene
@export var options_scene: PackedScene


func _on_singleplayer_button_button_up() -> void:
	get_tree().change_scene_to_packed(singleplayer_scene)

func _on_multiplayer_button_button_up() -> void:
	get_tree().change_scene_to_packed(lobby_scene)

func _on_options_button_button_up() -> void:
	get_tree().change_scene_to_packed(options_scene)

func _on_quit_button_button_up() -> void:
	get_tree().quit()
