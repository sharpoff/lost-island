extends Control

signal host_button_pressed
signal join_button_pressed

func _on_host_pressed() -> void:
	print_debug("host_pressed")
	host_button_pressed.emit()

func _on_join_pressed() -> void:
	print_debug("join_pressed")
	join_button_pressed.emit()

func _on_quit_pressed() -> void:
	print_debug("quit_pressed")
	get_tree().quit()
