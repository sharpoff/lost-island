extends Control

# TODO: make this global, so it changes everywhere
var main_menu_scene = "res://scenes/ui/menu_main.tscn"
var main_scene = "res://scenes/game/main.tscn"
@onready var option_button: OptionButton = $Panel/MarginContainer/Vertical/Middle/VBoxContainer/OptionButton
@onready var save_name: LineEdit = $Panel/MarginContainer/Vertical/Middle/VBoxContainer2/HBoxContainer/SaveName

func _ready() -> void:
	var saves = SaveManager.get_all_saves()
	if saves.is_empty():
		$Panel/MarginContainer/Vertical/Bottom/Play.disabled = true

	for save in saves:
		option_button.add_item(save)

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file(main_menu_scene)

func _on_play_button_up() -> void:
	SaveManager.save_filename = option_button.get_item_text(option_button.get_selected())
	GameManager.create_game()
	GameManager.change_scene.rpc(main_scene)

func _on_new_save_button_up() -> void:
	SaveManager.save_filename = save_name.text
	$Panel/MarginContainer/Vertical/Middle/VBoxContainer2/HBoxContainer/SaveName.text = ""
	$Panel/MarginContainer/Vertical/Bottom/Play.disabled = false
	option_button.add_item(SaveManager.save_filename)
