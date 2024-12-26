extends PanelContainer
class_name SellItem

signal pressed

var item: ItemData: set = set_item
@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label

func _on_button_button_up() -> void:
	pressed.emit()

func set_item(item_data):
	item = item_data
	if !item:
		return
	
	texture_rect.texture = item.texture
	label.text = item.name
