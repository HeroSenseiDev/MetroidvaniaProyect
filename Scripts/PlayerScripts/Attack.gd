extends Node2D
class_name Attack
var player : Player



func attack():
	var overlapping_objects = $"../AttackArea".get_overlapping_areas()
	
	for area in overlapping_objects:
		var parent = area.get_parent()
		print(parent.name)
