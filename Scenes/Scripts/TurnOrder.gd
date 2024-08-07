extends Node

var Round : Array[Node]

func sort_turn_order():
	for item in get_children():
		Round.append(item)
	Round.sort_custom(speed_sort)
	#print(Round)
	pass
	
func get_next_battler():
	return Round.pop_front()
	
func remove_battler(battler : Node):
	if battler in Round:
		Round.erase(battler)
	battler.queue_free()
	
static func speed_sort(a : Node, b : Node):
	return a.Stats.get_stat("speed") > b.Stats.get_stat("speed") 
