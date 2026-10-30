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
	info.text = "nVelocity: %s\nOn floor: %s\nAxis: %s" % [
		player.velocity.round(),
		player.is_on_floor(),
		dir.axis,
	]
	up.active = dir.up
	down.active = dir.down
	left.active = dir.left
	right.active = dir.right
