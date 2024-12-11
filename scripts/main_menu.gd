extends Control

signal host_button_pressed
signal join_button_pressed

func _on_host_pressed() -> void:
	host_button_pressed.emit()

func _on_join_pressed() -> void:
	join_button_pressed.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
