extends Node2D
class_name Checkpoint

@export var spawnpoint = false
var activated = false


func activate():
	GameManager.current_checkpoint = self
	activated = true
	GameManager.teletransported = false
	print("ACTIVADO")
	#play animation


func _on_area_2d_area_entered(area):
	if area.get_parent() is Player and !activated:
		activate()
