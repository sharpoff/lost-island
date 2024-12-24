extends Control

@onready var inventory: Control = $Inventory
@onready var hotbar: HBoxContainer = $Hotbar

@onready var inventory_slots: GridContainer = $Inventory/NinePatchRect/GridContainer
@onready var hotbar_slots: GridContainer = $Hotbar/GridContainer

const item_scene = preload("res://scenes/ui/item.tscn")

var is_grabbing = false
@onready var grabbed_item: ItemSlot = $GrabbedItem

func _physics_process(delta: float) -> void:
	if grabbed_item.visible:
		grabbed_item.position = get_local_mouse_position() + Vector2(5, 5)

func set_inventory_data(inventory: InventoryData) -> void:
	for child in inventory_slots.get_children():
		child.queue_free()
	
	for item in inventory.items:
		var item_ui = item_scene.instantiate()
		item_ui.item_pressed.connect(on_inventory_item_pressed)
		item_ui.item = item
		inventory_slots.add_child(item_ui)

func set_hotbar_data(hotbar: InventoryData) -> void:
	for child in hotbar_slots.get_children():
		child.queue_free()
	
	for item in hotbar.items:
		var item_ui = item_scene.instantiate()
		item_ui.item_pressed.connect(on_hotbar_item_pressed)
		item_ui.item = item
		hotbar_slots.add_child(item_ui)

func on_inventory_item_pressed(item_data: ItemData, item_index: int, button_index: int):
	print_debug("%s %s %s" % [item_data, item_index, button_index])

	inventory_slots.get_children()[item_index].item = grabbed_item.item
	grabbed_item.item = item_data
	if grabbed_item.item:
		grabbed_item.show()
	else:
		grabbed_item.hide()

func on_hotbar_item_pressed(item_data: ItemData, item_index: int, button_index: int):
	print_debug("%s %s %s" % [item_data, item_index, button_index])
	
	hotbar_slots.get_children()[item_index].item = grabbed_item.item
	grabbed_item.item = item_data
	if grabbed_item.item:
		grabbed_item.show()
	else:
		grabbed_item.hide()
