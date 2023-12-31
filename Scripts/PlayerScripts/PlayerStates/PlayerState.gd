extends Node
class_name PlayerState

var state_machine : StateMachine
var node : Player:
	set(value):
		node = value
		player = value
	get:
		return node

var player : Player

func enter():
	pass
