class_name DebugArrow
extends Control

# Draws an arrow that lights up when active.
# angle_degrees: 0 = up, 90 = right, 180 = down, 270 = left

@export var angle_degrees : float = 0.0
@export var active_color := Color(1.0, 0.35, 0.2)
@export var inactive_color := Color(1.0, 1.0, 1.0, 0.2)

var active := false:
	set(value):
		if value != active:
			active = value
			queue_redraw()

# Arrow shape pointing up, in a -1..1 box
const SHAPE = [
	Vector2(0, -1), Vector2(0.8, -0.1), Vector2(0.3, -0.1), Vector2(0.3, 0.9),
	Vector2(-0.3, 0.9), Vector2(-0.3, -0.1), Vector2(-0.8, -0.1),
]


func _draw() -> void:
	var center = size / 2
	var radius = min(size.x, size.y) / 2 * 0.9
	var points := PackedVector2Array()
	for p in SHAPE:
		points.append(center + p.rotated(deg_to_rad(angle_degrees)) * radius)
	draw_colored_polygon(points, active_color if active else inactive_color)
