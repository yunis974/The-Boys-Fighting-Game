extends State


func enter(_previous_state: State) -> void:
	player.jump()
	player.sprite.play("jump")


func physics_update(delta: float) -> void:
	player.move(delta)

	# Jump cut: releasing the button early makes a smaller jump
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= player.data.jump_cut_multiplier

	if player.velocity.y >= 0:
		state_machine.change_state("Fall")
