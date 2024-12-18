# holds all map related functionality
extends Control
class_name MainMenu

@export var lobby_menu: PackedScene
@export var options_menu: PackedScene

func _on_singleplayer_button_button_up() -> void:
	get_tree().change_scene_to_packed(lobby_menu)

func _on_multiplayer_button_button_up() -> void:
	get_tree().change_scene_to_packed(lobby_menu)

func _on_options_button_button_up() -> void:
	get_tree().change_scene_to_packed(options_menu)

func _on_quit_button_button_up() -> void:
	get_tree().quit()
