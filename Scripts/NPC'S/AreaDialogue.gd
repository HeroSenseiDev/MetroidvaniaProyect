extends Area2D

@onready var resource = preload("res://Dialogue/Master/NuevoDialogo.dialogue")
var dailoguestart : String = "start"

func action():
	DialogueManager.show_example_dialogue_balloon(resource)
