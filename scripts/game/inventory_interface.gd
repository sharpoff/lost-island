extends Control

@onready var inventory: Control = $Inventory
@onready var hotbar: HBoxContainer = $"VBoxContainer/Hotbar"

@onready var inventory_slots: GridContainer = $Inventory/NinePatchRect/GridContainer
@onready var hotbar_slots: GridContainer = hotbar.get_node("GridContainer")

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
	
	# TODO: check if item has equal type, quantity and if it's true decrease grabbed item quantity
	# and increase slot quantity
	var inv_item = inventory_slots.get_children()[item_index]
	inv_item.item = grabbed_item.item
	grabbed_item.item = item_data

	if grabbed_item.item:
		grabbed_item.show()
	else:
		grabbed_item.hide()

func on_hotbar_item_pressed(item_data: ItemData, item_index: int, button_index: int):
	if !inventory.visible: # can't move hotbar items if inventory is closed
		var player = get_tree().root.get_node("Main/Players/" + str(multiplayer.get_unique_id())) as Player
		player.selected_item = hotbar_slots.get_children()[item_index].item
		return

	print_debug("%s %s %s" % [item_data, item_index, button_index])
	
	var hotbar_item = hotbar_slots.get_children()[item_index]
	hotbar_item.item = grabbed_item.item
	grabbed_item.item = item_data
	if grabbed_item.item:
		grabbed_item.show()
	else:
		grabbed_item.hide()


func _on_hotbar_inventory_opened() -> void:
	inventory.visible = !inventory.visible
	
	var player = get_tree().root.get_node("Main/Players/" + str(multiplayer.get_unique_id()))
	player.can_move = !player.can_move
	player.can_click = !player.can_click
