extends Control
onready var timer = get_node('Timer')
var current_time

func _ready():
	get_node("start").set_visible(true)
	timer.set_wait_time(12.0)
	timer.start()	
	
func _process(delta):
	current_time = 6-int(timer.time_left)/2
	get_node('Label%s' % str(current_time)).set_visible(true)
