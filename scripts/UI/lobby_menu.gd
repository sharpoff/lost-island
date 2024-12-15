extends Control

@export var click: AudioStreamPlayer2D

func _on_back_button_button_up() -> void:
	click.play()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_play_button_button_up() -> void:
	# networking goes here i guess
	click.play()
	get_tree().change_scene_to_file("res://scenes/world.tscn")
