extends Control
onready var timer = get_node('Timer')
var total_time = 6
var current_time

func _ready():
	get_node("start").set_visible(true)
	timer.set_one_shot(true)
	timer.set_wait_time(12.0)
	timer.set_timer_process_mode(0)
	timer.start()	
	
func _process(delta):
	current_time = int(timer.time_left)/2
	print('Label%s' % str(6-current_time))
	get_node('Label%s' % str(6-current_time)).set_visible(true)
