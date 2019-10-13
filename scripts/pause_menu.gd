extends Control

var pause = false
var config_is_focused = false
var cfg_children_focused = false
var player_equipment_is_on = false
onready var player_equipment = get_node("player equipment/Sprite")

func _ready():
	player_equipment.set_visible(false)

func _process(delta):
	if Input.is_action_just_pressed('ui_cancel'):
		pause = is_paused(pause)
		
		
	if pause == true:
		show_menu(pause, config_is_focused, cfg_children_focused)
	elif pause == false:
		close_menu()	

	if player_equipment_is_on == true:
		player_equipment.set_visible(true)
		if Input.is_action_just_pressed('ui_cancel'):
			player_equipment.set_visible(false)	
			player_equipment_is_on = false
			
	elif player_equipment_is_on == false:
		player_equipment.set_visible(false)

func is_paused(pause):
	if pause == false:
		pause = true
	else:
		pause = false
	return pause
	
	
func show_menu(pause, config_is_focused, cfg_children_focused):

	if pause == true:
		get_node("player").set_visible(true)		
		get_node("inventory").set_visible(true)		
		get_node("stats").set_visible(true)		
		get_node("configs").set_visible(true)		
		get_node("quit").set_visible(true)		
		
		if config_is_focused == true or cfg_children_focused == true:
			get_node("video").set_visible(true)		
			get_node("audio").set_visible(true)		
			get_node("bindings").set_visible(true)
		else:
			get_node("video").set_visible(false)		
			get_node("audio").set_visible(false)		
			get_node("bindings").set_visible(false)
		
	
func close_menu():
	pause = false
	get_node("player").set_visible(false)		
	get_node("inventory").set_visible(false)		
	get_node("stats").set_visible(false)		
	get_node("configs").set_visible(false)		
	get_node("video").set_visible(false)		
	get_node("audio").set_visible(false)		
	get_node("bindings").set_visible(false)		
	get_node("quit").set_visible(false)



func _on_player_focus_entered():
	cfg_children_focused = false
	# pop-up player equipment
	if player_equipment_is_on == false:
		player_equipment_is_on = true
	else:
		player_equipment_is_on = false
	close_menu()
	
func _on_inventory_focus_entered():
	cfg_children_focused = false
	# pop-up player inventory
	
func _on_stats_focus_entered():
	cfg_children_focused = false
	# pop-up player stats
	
func _on_configs_focus_entered():
	config_is_focused = true
	cfg_children_focused = true

func _on_configs_focus_exited():
	config_is_focused = false
	
func _on_quit_focus_entered():
	cfg_children_focused = false
	# go to main menu
	get_tree().change_scene("res://Scenes/MAIN_MENU.tscn")
	
