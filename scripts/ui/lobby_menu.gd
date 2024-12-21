extends Control

# TODO: remove hardcoded scene string. maybe make it global in game_manager?
var world_scene = "res://scenes/game/world.tscn"
var main_menu_scene = "res://scenes/ui/menu_main.tscn"
@export var player_list: ItemList
@export var nickname: LineEdit
@export var ip_address: LineEdit
@export var error_msg: Label

func _on_play_button_button_up() -> void:
	# TODO: add multiplayer handling
	get_tree().change_scene_to_file(world_scene)

func _on_host_button_up() -> void:
	if nickname.text.is_empty():
		error_msg.text = tr("WRONG_NAME")
		error_msg.show()
		return
	error_msg.hide()
	
	$Players.show()
	$SelectMenu.hide()

func _on_join_button_up() -> void:
	if nickname.text.is_empty():
		error_msg.text = tr("WRONG_NAME")
		error_msg.show()
		return
	elif ip_address.text.is_empty():
		error_msg.text = tr("UNDEFINED_IP")
		error_msg.show()
		return
	error_msg.hide()
	
	$Players.show()
	$SelectMenu.hide()

func _on_hide_address_toggled(toggled_on: bool) -> void:
	ip_address.secret = toggled_on

func _on_back_to_select_button_up() -> void:
	$Players.hide()
	$SelectMenu.show()

func _on_back_to_menu_button_up() -> void:
	get_tree().change_scene_to_file(main_menu_scene)
