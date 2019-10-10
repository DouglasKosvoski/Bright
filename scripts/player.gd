extends KinematicBody2D

onready var anim = get_node("Sprite/AnimatedSprite")
var motion = Vector2()

const CONST_YSPEED = 1200
const GRAVITY = 40
const XSPEED = 400
const ACCELERATION = 1.5
var yspeed = CONST_YSPEED

var move = false
var dir = 'right'
var jump = false
var roll = false
var temp_roll = 0
var temp_atk = 0
var atk = false



func _physics_process(delta):
	motion.y += GRAVITY
	motion.x = 0

	if jump:
		if yspeed > 0:
			motion.y = -yspeed
			yspeed -= (GRAVITY * ACCELERATION)
		else:
			yspeed = CONST_YSPEED
			jump = false
	if move:
		if dir == 'left':
			motion.x -= XSPEED
		elif dir == 'right':
			motion.x += XSPEED
		move = false
	if atk:
		anim.play('attack')
		temp_atk += 1
		if temp_atk == 20:
			temp_atk = 0
			atk = false

			
	elif roll:
		if is_on_floor() == true:
			anim.play('roll')
			if dir == 'left':
				motion.x -= XSPEED
			elif dir == 'right':
				motion.x += XSPEED
			temp_roll += 1
			if temp_roll == 30:
				temp_roll = 0
				roll = false

	else:
		if Input.is_action_pressed('left'):
			dir = 'left'
			anim.set_flip_h(true)
			move = true
			anim.play("walk")
			
			if Input.is_action_pressed('roll'):
				roll = true
			elif Input.is_action_pressed('jump'):
				if is_on_floor() == true:
					jump = true
					
		elif Input.is_action_pressed('right'):
			dir = 'right'
			anim.set_flip_h(false)
			move = true
			anim.play("walk")  
			
			if Input.is_action_pressed('roll'):
				roll = true
			elif Input.is_action_just_pressed('jump'):
				if is_on_floor() == true:
					jump = true
				
		else:
			if Input.is_action_pressed('roll'):
				roll = true
			if Input.is_action_pressed('attack'):
				atk = true
			if Input.is_action_pressed('jump'):
				if is_on_floor() == true:
					jump = true
			else:
				anim.play("idle original fat")

	motion = move_and_slide(motion, Vector2(0,-1))
