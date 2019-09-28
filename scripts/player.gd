extends KinematicBody2D

var motion = Vector2()
const GRAVITY = 40
const speed = 600

onready var anim = get_node("Sprite/AnimatedSprite")
var move = false
var dir = 'right'


func _physics_process(delta):
	motion.y += GRAVITY
	motion.x = 0
	
	if move:
		if dir == 'left':
			motion.x -= speed
		elif dir == 'right':
			motion.x += speed
		move = false

	if Input.is_action_pressed('left'):
		dir = 'left'
		get_node("Sprite/AnimatedSprite").set_flip_h(true)
		move = true
		anim.play("walk")
	elif Input.is_action_pressed('right'):
		dir = 'right'
		get_node("Sprite/AnimatedSprite").set_flip_h(false)
		move = true
		anim.play("walk")
	else:
		if Input.is_action_pressed('left_ctrl'):
			if is_on_floor() == true:
				get_node("Sprite/AnimatedSprite").play('roll')
				if dir == 'left':
					motion.x -= speed
				elif dir == 'right':
					motion.x += speed
		elif Input.is_action_pressed('space'):
			get_node("Sprite/AnimatedSprite").play('attack')
		else:
			anim.play("idle")
			
#	if Input.is_action_just_pressed('space'):
#		if is_on_floor():
#			motion.y = -speed*1.5
			


	motion = move_and_slide(motion, Vector2(0,-1))
