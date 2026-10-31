class_name CharacterData
extends Resource

# All the tweakable values of a character.
# One character = one .tres file using this script.

@export var display_name : String = "Character"
@export var sprite_frames : SpriteFrames
@export var attacks : Array[Attack] = []

@export_group("Movement")
@export var speed : float = 300.0
@export var acceleration : float = 3000.0
@export var deceleration : float = 3000.0

@export_group("Gravity")
@export var gravity : float = 35.0
@export var jumping_gravity : float = 25.0

@export_group("Jump")
@export var jump_velocity : float = -650.0
@export var jump_cut_multiplier : float = 0.5
@export var coyote_time : float = 0.15
