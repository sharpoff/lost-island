extends Control

@export var click: AudioStreamPlayer2D


func _on_back_button_button_up() -> void:
	click.play()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_language_options_item_selected(index: int) -> void:
	SettingsManager.current_state = index

func _on_master_volume_slider_value_changed(value: float) -> void:
	SettingsManager.master_volume = value

func _on_sound_effects_slider_value_changed(value: float) -> void:
	SettingsManager.sound_effects = value
