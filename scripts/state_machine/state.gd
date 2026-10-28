class_name State
extends Node

# Base class for every state. Override only the functions you need.

# Set by the StateMachine
var player : Player
var state_machine : StateMachine


func enter(_previous_state: State) -> void:
	pass

func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func on_animation_finished() -> void:
	pass
