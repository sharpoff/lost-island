extends Control

var world_scene = "res://scenes/game/world.tscn"
var main_menu_scene = "res://scenes/ui/menu_main.tscn"
@export var player_list: ItemList
@export var Nickname: LineEdit
@export var IPAddress: LineEdit


func _on_back_button_button_up() -> void:
	get_tree().change_scene_to_file(main_menu_scene)

func _on_play_button_button_up() -> void:
	# TODO: handle multiplayer
	get_tree().change_scene_to_file(world_scene)

func _on_host_button_up() -> void:
	pass # Replace with function body.

func _on_join_button_up() -> void:
	pass # Replace with function body.

func _on_hide_address_toggled(toggled_on: bool) -> void:
	IPAddress.secret = toggled_on
