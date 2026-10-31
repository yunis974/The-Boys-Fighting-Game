class_name Player
extends CharacterBody2D

#--- Directional input snapshot, refreshed every physics frame ---
class InputDirection:
	var up: bool
	var down: bool
	var left: bool
	var right: bool
	var axis := Vector2.ZERO   # x: -1 left / +1 right, y: -1 down / +1 up
	
enum CharacterState {BLOCKING, ACTIVE, RECOVERING, AIRBORN, NEUTRAL}

@export var data: CharacterData

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var input_dir := InputDirection.new()
var is_jumping : bool = false 
var character_state := CharacterState.NEUTRAL
var character_frames : int = 0

func _ready() -> void:
	pass

func _update_frames() -> void:
	if character_frames != 0:
		character_frames += -1
		if character_state == CharacterState.RECOVERING:
			character_state = CharacterState.NEUTRAL
			
func _update_state() -> void:
	if input_dir.down == true and character_frames == 0:
		if input_dir.left == true or input_dir.right == true:
			character_state = CharacterState.BLOCKING
			
	if not is_on_floor() and character_state == CharacterState.AIRBORN:
		character_state = CharacterState.NEUTRAL
			
func _physics_process(delta: float) -> void:
	_update_input_direction()
	_update_frames()
	_update_state()

	if not is_on_floor():
		velocity.y += data.gravity * delta
	
	move(delta)
	jump()
	move_and_slide()

# --- Input ---

func _update_input_direction() -> void:
	input_dir.up = false
	input_dir.down = false
	input_dir.left = false
	input_dir.right = false
	
	var up_down := Input.get_axis("down", "up")
	var left_right := Input.get_axis("left", "right")

	input_dir.axis = Vector2(left_right, up_down)
	
	if input_dir.axis.y > input_dir.axis.x and input_dir.axis.y > 0:
		input_dir.up = true
	
	if input_dir.axis.y < input_dir.axis.x and input_dir.axis.y < 0:
		input_dir.down = true
		
	if input_dir.axis.x > abs(input_dir.axis.y) and input_dir.axis.x > 0:
		input_dir.right = true
		
	if abs(input_dir.axis.x) > input_dir.axis.y and input_dir.axis.x < 0:
		input_dir.left = true

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
	if !is_jumping:
		velocity.y = data.jump_velocity
		is_jumping = true
	
