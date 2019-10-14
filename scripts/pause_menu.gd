extends Control

var pause_master = false

var show_pause_icons = false
var config_is_focused = false
var cfg_children_focused = false

var player_equipment_is_on = false
var player_inventory_is_on = false
var player_stats_is_on   = false
var video_settings_is_on = false
var audio_settings_is_on = false
var binds_settings_is_on = false

onready var player_equipment = get_node("player equipment")
onready var player_inventory = get_node("inventario/Sprite")
onready var player_stats     = get_node("stats2/Sprite")
onready var video_settings   = get_node("video settings/Sprite")
onready var audio_settings   = get_node("audio settings/Sprite")
onready var binds_settings   = get_node("binds settings")


func _ready():
	player_equipment.set_visible(false)
	player_inventory.set_visible(false)
	player_stats.set_visible(false)
	video_settings.set_visible(false)
	audio_settings.set_visible(false)
	binds_settings.set_visible(false)

func verify_pause(show_pause_icons, player_equipment_is_on):
	if show_pause_icons == false and player_equipment_is_on == false:
		return false
	return true

func _process(delta):
	pause_master = verify_pause(show_pause_icons, player_equipment_is_on)
#	print("Master = ", pause_master)
	
	if Input.is_action_just_pressed('ui_cancel'):
		show_pause_icons = is_paused(show_pause_icons)

	if show_pause_icons == true:
		show_menu(config_is_focused, cfg_children_focused)
	elif show_pause_icons == false:
		close_menu()

	if player_equipment_is_on == true:
		player_equipment.set_visible(true)
		if Input.is_action_just_pressed('ui_cancel'):
			player_equipment.set_visible(false)
			player_equipment_is_on = false
			show_pause_icons = true

	elif player_equipment_is_on == false:
		player_equipment.set_visible(false)

func is_paused(show_pause_icons):
	if show_pause_icons == false:
		show_pause_icons = true
	else:
		show_pause_icons = false
	return show_pause_icons

		
func show_menu(config_is_focused, cfg_children_focused):
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
	show_pause_icons = false
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
	player_inventory = true

func _on_stats_focus_entered():
	cfg_children_focused = false
	# pop-up player stats
	player_stats = true

func _on_configs_focus_entered():
	config_is_focused = true
	cfg_children_focused = true

func _on_configs_focus_exited():
	config_is_focused = false

func _on_quit_focus_entered():
	cfg_children_focused = false
	# go to main menu
	get_tree().change_scene("res://Scenes/MAIN_MENU.tscn")
