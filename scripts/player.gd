extends KinematicBody2D

onready var anim = get_node("AnimatedSprite")
var motion = Vector2()
var FLOOR = Vector2(0,-1)

var temp # temporary

var direction = "right"

var is_walking = false
var is_jumping = false
var is_rolling = false
var roll_distance = 400
var temp_roll = 0

var xspeed = 400
var gravity = 30 			# 80
var normal_jump = 300*1.5 	# 800
var higher_jump = 15 		# 30
var fall_multiplier = 0.75 	# 1.5


func _physics_process(delta):
	motion = apply_gravity(motion, gravity)

	# set variables
	if Input.is_action_pressed("roll"):
		if is_on_floor() == true:
			is_walking = false
			is_jumping = false
			is_rolling = true

	elif Input.is_action_just_pressed("jump"):
		if is_on_floor() == true:
			is_walking = false
			is_rolling = false
			is_jumping = true

	elif Input.is_action_pressed("left"):
		direction = "left"
		is_walking = true
		is_jumping = false
#		is_rolling = false 		### descomentar se quiser que 'andar' cancele rolamento

	elif Input.is_action_pressed("right"):
		direction = "right"
		is_walking = true
		is_jumping = false
#		is_rolling = false 		### descomentar se quiser que 'andar' cancele rolamento
	else:
		motion.x = 0


	################################################
	# call the functions based on variables of control
	if is_jumping == true:
		motion = jump(motion, anim, normal_jump, higher_jump, fall_multiplier)

	elif is_rolling == true:
		motion = roll(motion, anim, direction, roll_distance, temp_roll)
	elif is_walking == true:
		var temp = move_left_right(motion, anim, direction, is_walking, xspeed)
		motion = temp[0]
		direction = temp[1]
		is_walking = false
	else:
		is_jumping = false
		is_rolling = false
		anim.play("idle slim")
		
	if motion != null:
		motion.x = int(motion.x)
		motion.y = int(motion.y)
		motion = move_and_slide(motion, FLOOR)
	
	#############################################3##

func apply_gravity(motion, g):
	if is_on_floor() == false:
		motion.y += g
	return motion

func move_left_right(motion, anim, direction, is_walking, xspeed):
	motion.x = 0
	if is_walking == true:
		if is_on_floor() == true:
			anim.play("walk")
			
		if direction == "right":
			motion.x = xspeed
			anim.set_flip_h(false)
		elif direction == "left":
			motion.x = -xspeed

			anim.set_flip_h(true)
	return [motion, direction]


func roll(motion, anim, direction, roll_distance, temp_roll):
	if direction == "right":
		motion.x = roll_distance
		anim.set_flip_h(false)

	elif direction == "left":
		motion.x = -roll_distance
		anim.set_flip_h(true)
	
	anim.play("roll")
	
	if anim.frame == 5:
		is_rolling = false

	return motion

func jump(motion, anim, normal_jump, higher_jump, fall_multiplier):
	# Player is falling
	if motion.y > 50:
		anim.play("jumping_down")
		motion += Vector2.UP * (-9.8) * (fall_multiplier)
		print(motion.y, "  DOWN")

	elif -50 <= motion.y && motion.y <= 50 && motion.y != 0:
		print(motion.y, "  MID")
		anim.play("jumping_mid")

	elif motion.y < -50 && Input.is_action_just_released("jump"): #Player is jumping
		# Higher jump
		# Jump Height depends on how long you will hold key
		print(motion.y, "  UP")
		anim.play("jumping_up")
		motion += Vector2.UP * (-9.8) * higher_jump * 2
		
	if direction == "left":
		anim.set_flip_h(true)
	elif direction == "right":
		anim.set_flip_h(false)
		
	# the first jump that ever will be called
	if is_on_floor():
		# Normal jump
		anim.play("idle slim")
#		is_jumping = false
		if Input.is_action_just_pressed("jump"):
			anim.play("jumping_up")
			motion += Vector2.UP * normal_jump * 2
	
	return motion
