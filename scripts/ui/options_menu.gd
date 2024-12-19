extends Control

enum back_button_func_type {MAIN_MENU, HIDE}
@export var back_button_func: back_button_func_type
var main_menu_scene = "res://scenes/ui/main_menu.tscn"
signal closed

func _on_back_button_button_up() -> void:
	if back_button_func == back_button_func_type.MAIN_MENU:
		get_tree().change_scene_to_file(main_menu_scene)
		pass
	else:
		closed.emit()

func _on_language_options_item_selected(index: int) -> void:
	@warning_ignore("int_as_enum_without_cast")
	SettingsManager.current_state = index

func _on_master_volume_slider_value_changed(value: float) -> void:
	SettingsManager.master_volume = value

func _on_sound_effects_slider_value_changed(value: float) -> void:
	SettingsManager.sound_effects_volume = value
