extends Control

enum back_button_func_type {MAIN_MENU, HIDE}
@export var back_button_func: back_button_func_type

signal closed

func _on_back_button_button_up() -> void:
	if back_button_func == back_button_func_type.MAIN_MENU:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	else:
		emit_signal("closed")

func _on_language_options_item_selected(index: int) -> void:
	SettingsManager.current_state = index

func _on_master_volume_slider_value_changed(value: float) -> void:
	SettingsManager.master_volume = value

func _on_sound_effects_slider_value_changed(value: float) -> void:
	SettingsManager.sound_effects_volume = value
