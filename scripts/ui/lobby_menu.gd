extends Control
class_name LobbyMenu

@export var main_menu_scene: PackedScene
@export var world_scene: PackedScene

func _on_back_button_button_up() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

func _on_play_button_button_up() -> void:
	if NetworkManager.is_single_player:
		get_tree().change_scene_to_packed(world_scene)
	else:
		# multiplayer
		get_tree().change_scene_to_packed(world_scene)
