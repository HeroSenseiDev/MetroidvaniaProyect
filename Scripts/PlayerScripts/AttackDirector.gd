extends Node2D

@export var hitbox : HitboxComponent
@export var orbit_radius = 250
var player : Player

func _process(delta):
	gamepad_joystick()
func gamepad_joystick():
	var direction : Vector2
	direction.x = Input.get_axis("left_move", "right_move")
	direction.y = Input.get_axis("up_move", "down_move")
	
	if direction != Vector2(0, 0):
		var normalized_direction = direction.normalized()
		var offset = normalized_direction * orbit_radius
		hitbox.global_position = global_position + offset
