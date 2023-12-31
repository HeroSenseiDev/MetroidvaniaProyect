extends TextureProgressBar

@export var health_component : HealthComponent

func _ready():
	max_value = health_component.max_health
	value = health_component.current_health
	
	health_component.onHealthChanged.connect(update_health)
	
func update_health(current_health):
	value = current_health
	
	if value <= 0:
		hide()
