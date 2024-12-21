extends Control

# TODO: make this global, so it changes everywhere
var main_menu_scene = "res://scenes/ui/menu_main.tscn"


func _on_back_button_up() -> void:
	get_tree().change_scene_to_file(main_menu_scene)

func _on_play_button_up() -> void:
	pass # Replace with function body.
