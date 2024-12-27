extends Resource
class_name ItemData

const MAX_STACK = 16

@export var name: String
@export var description: String
@export var texture: Texture
@export var sellable: bool = false
@export var price: int = 0

@export var stackable: bool = false
@export_range(1, MAX_STACK) var quantity: int = 1
