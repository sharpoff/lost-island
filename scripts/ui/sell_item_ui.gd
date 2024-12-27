extends PanelContainer
class_name SellItem

signal pressed(sell_item)

@export var texture_rect: TextureRect
@export var label: Label
var item: ItemData: set = set_item

func _on_button_button_up() -> void:
	pressed.emit(self)

func set_item(item_data):
	item = item_data
	if !item:
		return

	texture_rect.set_texture(item.texture)
	label.text = item.name + " " + str(item.price) + "$"
