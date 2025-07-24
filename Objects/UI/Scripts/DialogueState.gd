extends Node

var data : Dictionary
var test : String = "test"

func add_data(key : String, value : String):
	data[key] = value

func reset_data():
	data.clear()
