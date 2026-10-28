class_name Player
extends CharacterBody2D

#--- Directional input snapshot, refreshed every physics frame ---
class InputDirection:
	var up: bool
	var down: bool
	var left: bool
	var right: bool
	var axis := Vector2.ZERO   # x: -1 left / +1 right, y: -1 down / +1 up

@export var data: CharacterData

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine

var input_dir := InputDirection.new()


func _ready() -> void:
	sprite.sprite_frames = data.sprite_frames
	sprite.animation_finished.connect(_on_animation_finished)
	state_machine.init(self)


func _physics_process(delta: float) -> void:
	_update_input_direction()

	if not is_on_floor():
		velocity.y += data.gravity * delta

	state_machine.physics_update(delta)
	move_and_slide()


# --- Input ---

func _update_input_direction() -> void:
	var up_down := Input.get_axis("down", "up")
	var left_right := Input.get_axis("left", "right")

	input_dir.axis = Vector2(left_right, up_down)
	
	if input_dir.axis.y > input_dir.axis.x and input_dir.axis.y > 0:
		input_dir.up = true
		input_dir.down = false
		input_dir.left = false
		input_dir.right = false
	
	if input_dir.axis.y < input_dir.axis.x and input_dir.axis.y < 0:
		input_dir.up = false
		input_dir.down = true
		input_dir.left = false
		input_dir.right = false
		
	if input_dir.axis.x > abs(input_dir.axis.y) and input_dir.axis.x > 0:
		input_dir.up = false
		input_dir.down = false
		input_dir.left = false
		input_dir.right = true
		
	if abs(input_dir.axis.x) > input_dir.axis.y and input_dir.axis.x < 0:
		input_dir.up = false
		input_dir.down = false
		input_dir.left = true
		input_dir.right = false
	
	if input_dir.axis == Vector2(0,0):
		input_dir.up = false
		input_dir.down = false
		input_dir.left = false
		input_dir.right = false
	
	#input_dir.up = up_down > 0 and input_dir.axis.y > input_dir.axis.x
	#input_dir.down = up_down < 0 and input_dir.axis.y < input_dir.axis.x
	#input_dir.left = left_right < 0 
	#input_dir.right = left_right > 0


# --- Helpers used by the states ---

func get_input_direction() -> float:
	return input_dir.axis.x


func move(delta: float) -> void:
	var direction := get_input_direction()
	if direction != 0.0:
		sprite.flip_h = direction < 0
		velocity.x = move_toward(velocity.x, direction * data.speed, data.acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, data.deceleration * delta)


func jump() -> void:
	velocity.y = data.jump_velocity


func _on_animation_finished() -> void:
	if state_machine.current_state:
		state_machine.current_state.on_animation_finished()
