extends CharacterBody2D
class_name Player

@export var speed = 1800
@export var jump_force = -2500
@export var collision = CollisionShape2D
@export var jump_particles : CPUParticles2D
@export var health_component : HealthComponent

@onready var movement: Movement = $"Movement" as Movement
@onready var jump: Jump = $"Jump" as Jump

var attacking : bool
@onready var animsprite : Sprite2D = $Sprite2D
@export var animplayer  : AnimationPlayer
@onready var animTree : AnimationTree = $AnimationTree
@onready var playback : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")


@onready var actionable_finder = $ActionableFinder


var input_axis : Vector2

var max_health = 2
var health = 0
var can_take_damage = true

func state_machine() -> void:
	match playback.get_current_node():
		"Idle":
			print("El personaje esta en Idle")
		"Run":
			print("Esta corriendo")
		"Attack":
			print("Atacando")
		"Dash":
			print("Voy rapidisimo")
		"Jump":
			print("Saltando")

func _ready():
	health_component.onDead.connect(func(): dead())
	health_component.onDamageTook.connect(func(): hurted())
	movement.setup(self)
	jump.setup(self)
	health = max_health
	GameManager.player = self

func _process(delta):
	flip_sprite()
	motion()
	attack()
	state_machine()


func _physics_process(delta):
	#if is_on_floor():
		#movement.can_dash = true
	input_axis.x = Input.get_axis("left_move", "right_move")
	
	#Estuvo en la plataforma en el suelo.
	movement.update(delta)
	jump.update(delta)
	move_and_slide()
	
	
	
func flip_sprite():
	if velocity.x < 0:
		animsprite.flip_h = true
		movement.raycast.target_position.x = -15
	elif velocity.x > 0:
		animsprite.flip_h = false
		movement.raycast.target_position.x = 15

		
		
func motion():
	if  is_on_floor():
		if movement.is_moving and movement.dashing == false:
			playback.travel("Run")
		elif not movement.is_moving:
			playback.travel("Idle")
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down_move") and is_on_floor():
		position.y += 1.5
		
func dead():
	queue_free()
	
func hurted():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", Color.RED, 0.4)
	tween.tween_property(self, "modulate", Color.WHITE, 0.4)
	
func attack():
	if Input.is_action_just_pressed("attack"):
		playback.travel("Attack")
		
func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("interact"):
		var actionable = actionable_finder.get_overlapping_areas()
		if actionable.size() > 0:
			print("Hay NPC en el area")
			actionable[0].action()
			return
