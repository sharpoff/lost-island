extends PanelContainer

func _on_close_button_up() -> void:
	SignalBus.emit_signal("close_dealer_ui")
