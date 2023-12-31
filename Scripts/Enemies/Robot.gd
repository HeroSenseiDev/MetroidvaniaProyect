extends CharacterBody2D

var speed = -1000
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var health_component = $HealthComponent

var facing_right = false
var dead = false
func _ready():
	health_component.onDead.connect(func(): die())
	health_component.onDamageTook.connect(func(): hurted())

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if !$RayCast2D.is_colliding() and is_on_floor():
		flip()

	velocity.x = speed
	move_and_slide()

func flip():
	facing_right = !facing_right
	$AnimationPlayer.play("Run")
	$Sprite2D.flip_h = not $Sprite2D.flip_h
	if facing_right:
		speed = abs(speed)
		$RayCast2D.position.x = 57
	else:
		speed = abs(speed) * -1
		$RayCast2D.position.x = -57


func die():
	dead = true
	speed = 0
	$AnimationPlayer.play("Die")
	
func hurted():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", Color.RED, 0.4)
	tween.tween_property(self, "modulate", Color.WHITE, 0.4)
