extends Node2D
class_name SpeedComponent

@export var speed: float

func slow_down(value: float) -> void:
	speed -= value

func speed_up(value: float) -> void:
	speed += value
