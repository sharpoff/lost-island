# holds all map related functionality
extends Control

@export var click: AudioStreamPlayer2D

func _on_singleplayer_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/lobby_menu.tscn")

func _on_multiplayer_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/lobby_menu.tscn")

func _on_options_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")

func _on_quit_button_button_up() -> void:
	get_tree().quit()
