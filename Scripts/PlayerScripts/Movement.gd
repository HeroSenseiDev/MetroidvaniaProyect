extends Node2D
class_name  Movement

@export var acceleration = 60000
@export var friction = 60000

var dashing = false
var dash_direction = Vector2(1, 0)
@export var raycast : RayCast2D

var tick = 0
var player : Player
var jump : Jump
var can_dash = true
@onready var can_dash_timer : Timer = $"../canDashTimer"
var is_moving:
	get:
		return player .velocity.x != 0
		
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func setup(body):
	player = body

func update(delta):
	tick = delta
	
	apply_gravity(delta)
	move(player.input_axis)
	wall_slide()
	dash()

func move(direction):
	if direction.x !=0:
		player.velocity.x = move_toward(player.velocity.x, direction.x * player.speed, acceleration * tick)
	elif direction.x == 0:
		player.velocity.x = move_toward(player.velocity.x, 0.0 , friction * tick)


func apply_gravity(delta):
	if not player.is_on_floor():
		player.velocity.y += gravity * delta
		player.velocity.y = clampf(player.velocity.y, -25000, 15000)
		
	
func wall_slide():
	
	if raycast.is_colliding():
		if raycast.get_collider().name == "TileMap":
			if not player.is_on_wall_only(): 
				return
			
			if is_facing_wall(): return
			if Input.is_action_pressed("down_move") and Input.is_action_pressed("jump"):
				player.playback.travel("Jump")
				return
			
			if player.is_on_wall():
				player.velocity.y = player.velocity.y * 0.7
				player.playback.travel("Slide")
				
				
			if Input.is_action_pressed("down_move"):
				player.velocity.y = player.velocity.y * 1.3
				player.playback.travel("Slide")
	elif !raycast.is_colliding():
			if player.velocity.y > 0:
				player.playback.travel("Jump")
			


func is_facing_wall():
	return player.get_wall_normal().x == player.velocity.x

func dash():
	if Input.is_action_pressed("right_move"):
		dash_direction = Vector2(1, 0)
	if Input.is_action_pressed("left_move"):
		dash_direction = Vector2(-1, 0)
	if Input.is_action_just_pressed("dash") and can_dash:
		player.velocity = dash_direction.normalized() * 12000
		player.playback.travel("Dash")
		dashing = true
		can_dash = false
		$"../dashTimer".wait_time = 0.3
		$"../dashTimer".start()
		$"../canDashTimer".wait_time = 0.8
		$"../canDashTimer".start()

func _on_dash_timer_timeout():
	dashing = false
	if dashing == false:
		player.speed = 1800


func _on_can_dash_timer_timeout():
	can_dash = true
