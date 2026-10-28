extends State


func enter(_previous_state: State) -> void:
	player.sprite.play("run")


func physics_update(delta: float) -> void:
	player.move(delta)

	if !player.is_on_floor():
		state_machine.change_state("Fall")
	elif Input.is_action_just_pressed("jump"):
		state_machine.change_state("Jump")
	elif !player.get_input_direction():
		state_machine.change_state("RunStop")
