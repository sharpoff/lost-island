extends Control

var world_scene = "res://scenes/game/world.tscn"
var main_menu_scene = "res://scenes/ui/main_menu.tscn"

func _on_back_button_button_up() -> void:
	get_tree().change_scene_to_file(main_menu_scene)

func _on_play_button_button_up() -> void:
	if NetworkManager.is_single_player:
		get_tree().change_scene_to_file(world_scene)
	else:
		# multiplayer
		get_tree().change_scene_to_file(world_scene)
