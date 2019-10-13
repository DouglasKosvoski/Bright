extends KinematicBody2D

onready var anim = get_node("Sprite/AnimatedSprite")
var motion = Vector2()

const CONST_YSPEED = 1200
const ACCELERATION = 1.5
const GRAVITY = 50
const XSPEED = 400
var yspeed = CONST_YSPEED

var move = false
var dir = 'right'
var jump = false
var roll = false
var temp_roll = 0
var temp_atk = 0
var atk = false

func _move_left_right(dir, motionX, speed):
	if dir == 'left':
		motionX -= speed
	elif dir == 'right':
		motionX += speed
	return motionX

func _jump(motionY, speed, gravity, acceleration):
	motionY = -speed
	yspeed -= (gravity * acceleration)
	return motionY

func _attack(anim, atk, temp_atk):
	anim.play('attack')
	if temp_atk <= 20:
		if temp_atk == 20:
			temp_atk = 0
			atk = false
		temp_atk += 1	
	return [atk, temp_atk]
	
func _move_and_animation():
	if jump:
		if yspeed > 0:
			motion.y = _jump(motion.y, yspeed, GRAVITY, ACCELERATION)
		else:
			yspeed = CONST_YSPEED
			jump = false

	if move == true:
		motion.x = _move_left_right(dir, motion.x, XSPEED)
		move = false

	if atk == true:
		var value = _attack(anim, atk, temp_atk)
		atk = value[0]
		temp_atk = value[1]
		
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
func _apply_gravity(force):
	motion.y += force

func _physics_process(delta):
	_apply_gravity(GRAVITY)
	motion.x = 0

	_move_and_animation()


	motion = move_and_slide(motion, Vector2(0,-1))
