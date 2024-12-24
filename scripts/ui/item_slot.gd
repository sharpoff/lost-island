extends Control
class_name ItemSlot

signal item_pressed(item_data: ItemData, item_index: int, button_index: int)

@export var quantity_label: Label
@export var texture_rect: TextureRect

var item: ItemData: set = set_item

func set_item(new_item):
	item = new_item
	if !item:
		texture_rect.hide()
		quantity_label.hide()
		return

	if item.texture:
		texture_rect.set_texture(item.texture)
		texture_rect.show()
	
	if item.stackable:
		quantity_label.show()
		quantity_label.text = str(item.quantity)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			item_pressed.emit(item, get_index(), event.button_index)
