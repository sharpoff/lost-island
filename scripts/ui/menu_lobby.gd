extends Control

# TODO: remove hardcoded scene string. maybe make it global in game_manager?
var main_scene = "res://scenes/game/main.tscn"
var main_menu_scene = "res://scenes/ui/menu_main.tscn"
@export var player_list: ItemList
@export var nickname: LineEdit
@export var ip_address: LineEdit
@export var error_msg: Label

@export var host_button: Button
@export var join_button: Button
@export var play_button: Button

func _ready() -> void:
	GameManager.player_connected.connect(_on_player_connected)
	GameManager.player_disconnected.connect(_on_player_disconnected)
	GameManager.server_disconnected.connect(_on_server_disconnected)
	GameManager.net_error.connect(_on_network_error)

func _on_play_button_button_up() -> void:
	host_button.disabled = true
	join_button.disabled = true
	GameManager.change_scene.rpc(main_scene)

func _on_host_button_up() -> void:
	if nickname.text.is_empty():
		error_msg.text = tr("WRONG_NAME")
		error_msg.show()
		return
	error_msg.hide()
	
	GameManager.player_info["name"] = nickname.text
	GameManager.create_game()

	_show_players()
	play_button.disabled = false

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
	
	GameManager.player_info["name"] = nickname.text
	
	GameManager.join_game(ip_address.text)
	host_button.disabled = true
	join_button.disabled = true
	play_button.disabled = true

func _on_hide_address_toggled(toggled_on: bool) -> void:
	ip_address.secret = toggled_on

func _on_back_to_select_button_up() -> void:
	GameManager._disconnect()
	player_list.clear()
	_show_select_menu()

func _on_back_to_menu_button_up() -> void:
	GameManager._disconnect()
	player_list.clear()
	get_tree().change_scene_to_file(main_menu_scene)

func _on_player_connected(peer_id: int, player_info: Dictionary) -> void:
	_show_players()
	_refresh_players_list(peer_id, player_info)

func _on_player_disconnected(peer_id) -> void:
	_refresh_players_list(peer_id, null)

func _on_server_disconnected() -> void:
	GameManager._disconnect()
	player_list.clear()
	_show_select_menu()

func _on_network_error(what):
	push_error("Network error: ", what)
	GameManager._disconnect()
	player_list.clear()
	_show_select_menu()

func _refresh_players_list(peer_id, player_info) -> void:
	if player_info == null or peer_id == null:
		player_list.clear()
		player_list.add_item(GameManager.player_info.get("name"))
		return

	var player_name = player_info.get("name")
	if player_name != null:
		player_list.add_item(player_name)

func _show_players():
	$Players.show()
	$SelectMenu.hide()
	host_button.disabled = true
	join_button.disabled = true

func _show_select_menu():
	$Players.hide()
	$SelectMenu.show()
	host_button.disabled = false
	join_button.disabled = false
