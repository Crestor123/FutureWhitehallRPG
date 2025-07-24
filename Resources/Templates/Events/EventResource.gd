class_name EventResource extends Resource

var Game : Node = null
var UI : Node = null
var Player : Node = null

signal endEvent

func process_event():
	pass

func create_message():
	pass

func end_event():
	Game.end_interact()
	pass
