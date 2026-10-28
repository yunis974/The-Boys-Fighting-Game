class_name StateMachine
extends Node

# Every child node with a State script is a state.
# Switch with change_state("NodeName").

@export var initial_state : State

var current_state : State


func init(player: Player) -> void:
	for child in get_children():
		if child is State:
			child.player = player
			child.state_machine = self
	current_state = initial_state
	current_state.enter(null)


func physics_update(delta: float) -> void:
	current_state.physics_update(delta)


func change_state(state_name: String) -> void:
	var new_state : State = get_node(state_name)
	var previous_state = current_state
	current_state.exit()
	current_state = new_state
	#print(previous_state.name, " -> ", state_name)
	current_state.enter(previous_state)
