extends Panel
class_name ItemSlot

signal dragged
signal released

var is_dragging = false
var delay = 0.5
var offset = 0

var item: Item:
	set(value):
		item = value
		$ItemTexture.texture = item.texture

#func _physics_process(delta: float) -> void:
	#if is_dragging:
		#var tween = get_tree().create_tween()
		#tween.tween_property($ItemTexture, "position", get_local_mouse_position() - offset, delay * delta)

func _on_item_texture_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if item and item.texture:
				dragged.emit(self)
		else:
			if item and item.texture:
				released.emit(self)
