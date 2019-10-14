extends KinematicBody2D

onready var anim = get_node("Sprite/AnimatedSprite")
var motion = Vector2()

# define some constants to the player
const XSPEED = 400 			# horizontal speed
const YSPEED = 1200			# vertical speed
const ACCELERATION = 1.5	# jump acceleration
const GRAVITY = 50			# 'vertical' force pushing down


# this var will be modified on the jump function
var yspeed = YSPEED

var temp_roll = 0
var temp_atk = 0
var move = false
var dir = 'right'
var jump = false
var roll = false
var atk = false

### Main loop
func _physics_process(delta):
	# apply gravity to the player
	_apply_gravity(GRAVITY)
	# set player horizontal movement back to X (otherwise it won't stop)
	motion.x = 0
	_move_and_animation()
	motion = move_and_slide(motion, Vector2(0,-1))


# apply gravity to player on the Y-axis
func _apply_gravity(force):
	motion.y += force

# when direction key are pressed move player on the X-axis
func _move_left_right(dir, motionX, speed):
	if dir == 'left':
		motionX -= speed
	elif dir == 'right':
		motionX += speed
	return motionX

# when jump key is pressed apply force and acceleration on Y-axis
func _jump(motionY, speed, gravity, acceleration):
	motionY = -speed
	yspeed -= (gravity * acceleration)
	return motionY

# when attack key is pressed play attack animation
func _attack(anim, atk, temp_atk):
	anim.play('attack')
	if temp_atk <= 20:
		if temp_atk == 20:
			temp_atk = 0
			atk = false
		temp_atk += 1
	return [atk, temp_atk]

# when roll key is pressed play animation and move player forward
func _roll(anim, dir, motionX, temp_roll, roll):
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
	return [roll, temp_roll]
	
# function responsible to control animations and sequences
func _move_and_animation():
	if jump == true:
		if yspeed > 0:
			motion.y = _jump(motion.y, yspeed, GRAVITY, ACCELERATION)
		else:
			yspeed = YSPEED
			jump = false

	if move == true:
		motion.x = _move_left_right(dir, motion.x, XSPEED)
		move = false

	if atk == true:
		var value = _attack(anim, atk, temp_atk)
		atk = value[0]
		temp_atk = value[1]
		
	elif roll == true:
		var value = _roll(anim, dir, motion.x, temp_roll, roll)
		roll = value[0]
		temp_roll = value[1]

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
