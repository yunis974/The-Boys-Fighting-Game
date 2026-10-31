extends Control

# Simple debug overlay: shows some player values and the input direction

@export var player : Player

@onready var info : Label = %Info
@onready var up : DebugArrow = %Up
@onready var down : DebugArrow = %Down
@onready var left : DebugArrow = %Left
@onready var right : DebugArrow = %Right


func _process(_delta: float) -> void:
	var dir = player.input_dir
	info.text = "nVelocity: %s\nOn floor: %s\nis_jumping: %s\nis_coyote: %s\nWas_on_floor: %s\ncharacter_state: %s\ninput_buf: %s" % [
		player.velocity.round(),
		player.on_floor,
		player.is_jumping,
		player.is_in_coyote,
		player.was_on_floor,
		player.CharacterState.find_key(player.character_state),
		player.input_buf.map(func(i): return player.CharacterInput.find_key(i))
	]
	up.active = dir.up
	down.active = dir.down
	left.active = dir.left
	right.active = dir.right
