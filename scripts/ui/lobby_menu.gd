extends Control

@export var click: AudioStreamPlayer2D

func _on_back_button_button_up() -> void:
	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_play_button_button_up() -> void:
	
	if NetworkManager.is_single_player:
		get_tree().change_scene_to_file("res://scenes/world.tscn")
	else:
		# multiplayer
		get_tree().change_scene_to_file("res://scenes/world.tscn")
