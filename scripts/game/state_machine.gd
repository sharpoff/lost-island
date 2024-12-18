extends Node
class_name StateMachine

var states: Dictionary = {}
var current_state : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(_on_child_transition)

func _enter_tree() -> void:
	if current_state:
		current_state.enter_tree()

func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)

func _on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		return
	
	if current_state:
		current_state.exit_tree()
	
	new_state.enter_tree()
	current_state = new_state
