extends Control

@onready var inventory_ui: Control = $Inventory
@onready var hotbar_ui: HBoxContainer = $VBoxContainer/Hotbar

@onready var inventory_slots: GridContainer = $Inventory/NinePatchRect/GridContainer
@onready var hotbar_slots: GridContainer = hotbar_ui.get_node("GridContainer")

@onready var trader_sell_slots: VBoxContainer = $DealerUI/VBoxContainer/Margin/Interface/ScrollContainer/SellItems

const item_scene = preload("res://scenes/ui/item.tscn")
const sell_item_scene = preload("res://scenes/ui/sell_item_ui.tscn")

var is_grabbing = false
@onready var grabbed_item: ItemSlot = $GrabbedItem

func _ready() -> void:
	SignalBus.connect("show_dealer_ui", show_dealer_ui)
	SignalBus.connect("close_dealer_ui", close_dealer_ui)
	SignalBus.connect("set_inventory_data", set_inventory_data)
	SignalBus.connect("set_hotbar_data", set_hotbar_data)

func _physics_process(_delta: float) -> void:
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
	if !inventory_ui.visible: # can't move hotbar items if inventory is closed
		GameManager.current_player.selected_item = hotbar_slots.get_children()[item_index].item
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
	inventory_ui.visible = !inventory_ui.visible
	
	GameManager.current_player.can_move = !GameManager.current_player.can_move
	GameManager.current_player.can_click = !GameManager.current_player.can_click

func show_dealer_ui() -> void:
	print_debug("Dealer")
	set_sell_slots()
	$DealerUI.show()

func close_dealer_ui() -> void:
	$DealerUI.hide()

func set_sell_slots() -> void:
	var inventory = GameManager.current_player.inventory

	for child in trader_sell_slots.get_children():
		child.queue_free()

	for item in inventory.items:
		if !item or !item.sellable:
			continue
		var sell_item = sell_item_scene.instantiate() as SellItem
		sell_item.pressed.connect(_on_sell_item)
		sell_item.item = item
		trader_sell_slots.add_child(sell_item)

func _on_sell_item(sell_item) -> void:
	if sell_item:
		for item in GameManager.current_player.inventory.items:
			if item == sell_item.item:
				item = null
				set_inventory_data(GameManager.current_player.inventory)
				break
		SignalBus.emit_signal("increase_coins", sell_item.item.price)
		set_sell_slots()
