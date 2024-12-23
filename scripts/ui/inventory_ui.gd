extends Control

@export var inventory: Inventory
@onready var slots = $NinePatchRect/GridContainer.get_children()

var is_dragging = false
var dragging_texture
var offset = 0
var delay = 0.5

func _ready():
	for i in range(len(slots)):
		slots[i].dragged.connect(_on_dragging)
		slots[i].released.connect(_on_release)
		if inventory.items[i] != null:
			slots[i].item = inventory.items[i]

func _physics_process(delta: float) -> void:
	if is_dragging:
		var tween = get_tree().create_tween()
		tween.tween_property(dragging_texture, "position", get_local_mouse_position() - offset, delay * delta)

func _on_dragging(slot: ItemSlot) -> void:
	dragging_texture = slot.get_node("ItemTexture")
	offset = get_local_mouse_position() - dragging_texture.position
	print_debug(dragging_texture.position)
	print_debug("pressed slot")

func _on_release(slot: ItemSlot) -> void:
	print_debug(dragging_texture.position)
	print_debug("released slot")
