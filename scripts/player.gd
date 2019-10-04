extends KinematicBody2D

onready var anim = get_node("Sprite/AnimatedSprite")
var motion = Vector2()
const GRAVITY = 40
const speed = 400


var move = false
var dir = 'right'
var roll = false
var temp_roll = 0
var temp_atk = 0
var atk = false

func _physics_process(delta):
	motion.y += GRAVITY
	motion.x = 0

	if move:
		if dir == 'left':
			motion.x -= speed
		elif dir == 'right':
			motion.x += speed
		move = false

	if atk:
		anim.play('attack')
		temp_atk += 1
		if temp_atk == 20:
			temp_atk = 0
			atk = false
	elif roll:
		anim.play('roll')
		if is_on_floor() == true:
			if dir == 'left':
				motion.x -= speed
			elif dir == 'right':
				motion.x += speed
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
			if Input.is_action_pressed('left_ctrl'):
				roll = true
				
		elif Input.is_action_pressed('right'):
			dir = 'right'
			anim.set_flip_h(false)
			move = true
			anim.play("walk")  
			if Input.is_action_pressed('left_ctrl'):
				roll = true
				
		else:
			if Input.is_action_pressed('left_ctrl'):
				roll = true
			if Input.is_action_pressed('space'):
				atk = true
			else:
				anim.play("idle")

	motion = move_and_slide(motion, Vector2(0,-1))
