extends Control

# TODO: make this global, so it changes everywhere
var main_menu_scene = "res://scenes/ui/menu_main.tscn"
var main_scene = "res://scenes/game/main.tscn"

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file(main_menu_scene)

func _on_play_button_up() -> void:
	GameManager.create_game()
	GameManager.change_scene.rpc(main_scene)
