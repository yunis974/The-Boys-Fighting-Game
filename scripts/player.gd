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

@onready var coyote_tim = $Coyote_timer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ground_cast = $Ground_cast
@export var coyote_time = 0.5
var coyete_time_counter = coyote_time


var input_dir := InputDirection.new()
var is_in_coyote := false
var can_coyote := false
var on_floor := false
var was_on_floor = false
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
	check_on_ground()
	move()
	_update_frames()
	_update_state()
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
	
	if up_down > 0:
		input_dir.up = true
	elif up_down < 0:
		input_dir.down = true
	else:
		input_dir.up = false
		input_dir.down = false
		
	if left_right > 0:
		input_dir.right = true
	elif left_right < 0:
		input_dir.left = true
	else:
		input_dir.right = false
		input_dir.left = false


func get_input_direction() -> float:
	return input_dir.axis.x


func move() -> void:
	var direction := get_input_direction()
	if direction != 0.0:
		sprite.flip_h = direction < 0
		velocity.x = move_toward(velocity.x, direction * data.speed, data.acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0.0, data.deceleration)


func jump() -> void:
	if Input.is_action_just_pressed("jump") && (on_floor || is_in_coyote):
		is_jumping = true
		velocity.y = data.jump_velocity
		is_in_coyote = false
		coyote_tim.stop()
	
	if Input.is_action_just_released("jump") && is_jumping && velocity.y < 0:
		velocity.y *= data.jump_cut_multiplier


	if !on_floor:
		velocity.y += data.gravity
		if can_coyote && !is_jumping:
			can_coyote = false
			coyote_tim.start()
			is_in_coyote = true



func _on_coyote_timer_timeout() -> void:
	is_in_coyote = false


func check_on_ground():
	if ground_cast.is_colliding() && velocity.y >= 0.0:
		on_floor = true
		is_jumping = false
		is_in_coyote = false
		can_coyote = true
		coyote_tim.stop()
	else:
		on_floor = false
