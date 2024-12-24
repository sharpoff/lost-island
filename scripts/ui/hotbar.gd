extends HBoxContainer

signal inventory_opened

func _on_button_button_up() -> void:
	inventory_opened.emit()
