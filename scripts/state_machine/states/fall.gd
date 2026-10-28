extends State

var coyote_timer := 0.0


func enter(previous_state: State) -> void:
	player.sprite.play("fall")
	# Coyote time only if we walked off a ledge, not after a jump
	if previous_state and previous_state.name != "Jump":
		coyote_timer = player.data.coyote_time
	else:
		coyote_timer = 0.0


func physics_update(delta: float) -> void:
	player.move(delta)
	coyote_timer -= delta

	if Input.is_action_just_pressed("jump") and coyote_timer > 0:
		state_machine.change_state("Jump")
	elif player.is_on_floor():
		if player.get_input_direction():
			state_machine.change_state("Run")
		else:
			state_machine.change_state("Idle")


func on_animation_finished() -> void:
	player.sprite.play("fall_loop")
