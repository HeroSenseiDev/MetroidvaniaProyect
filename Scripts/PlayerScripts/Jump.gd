extends Node2D
class_name Jump

var player: Player
@onready var movement = $"../Movement"
var air_jump : bool
const wall_jump_pushback = 5000




# Called when the node enters the scene tree for the first time.
func setup(body) -> void:
	player = body



# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	
	if player.is_on_floor():
		air_jump = true
	
	if player.is_on_floor():
		#Normal Jump
		if Input.is_action_just_pressed("jump"):
			player.velocity.y = player.jump_force
			player.playback.travel("Jump")
			player.jump_particles.emitting = true
 	#Double Jump
	elif not player.is_on_floor():
		if Input.is_action_just_pressed("jump") and air_jump:
			player.velocity.y = player.jump_force * 0.7
			player.jump_particles.emitting = true
			air_jump = false
			player.playback.travel("Jump")
	#Wall CLimb (Wall Jump)
	if player.is_on_wall() and Input.is_action_pressed("right_move") and Input.is_action_just_pressed("jump"):
			player.velocity.y = player.jump_force
			player.velocity.x = -wall_jump_pushback
			player.playback.travel("Jump")
	if player.is_on_wall() and Input.is_action_pressed("left_move") and Input.is_action_just_pressed("jump"):
			player.velocity.y = player.jump_force
			player.velocity.x = wall_jump_pushback
			player.playback.travel("Jump")
	#Wall Jump(Wall impulse)
	if movement.raycast.is_colliding() and not player.is_on_floor():
		if movement.raycast.get_collider().name == "TileMap":
			var wall_normal = player.get_wall_normal()
			if Input.is_action_just_pressed("left_move") and wall_normal == Vector2.LEFT:
				player.velocity.x = wall_normal.x * player.speed
				player.velocity.y = player.jump_force
				player.playback.travel("Jump")
			if Input.is_action_just_pressed("right_move") and wall_normal == Vector2.RIGHT:
				player.velocity.x = wall_normal.x * player.speed
				player.velocity.y = player.jump_force
				player.playback.travel("Jump")
	

