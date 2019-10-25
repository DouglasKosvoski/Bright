## muito promissor

## boa animacao de pulo
## pulo variavel
## logica meio estranha

extends KinematicBody2D

var motion = Vector2()
onready var anim = get_node("Sprite/AnimatedSprite")

# jump related variables
export var fall_multiplier = 1.5	# how fast it'll get down
export var normal_jump = 500		# base jump height (affects the higher one)
export var higher_jump = 30			# is less than the normal cos is a factor that will multiply

export var gravity = 20
var is_rotated = false

var dir = "right"
var xspeed = 400

var jump = false
var move = true
var temp

func _physics_process(delta):
	# set player horizontal movement back to 0 (otherwise it won't stop)
	motion.x = 0

	# send player to the ground
	motion = _apply_gravity(gravity)
	motion = _jump(motion, anim, is_rotated, normal_jump, higher_jump, fall_multiplier)
	motion = move_and_slide(motion, Vector2(0,-1))


# apply gravity to player on the Y-axis
func _apply_gravity(force):
	motion.y += force
	return motion


# jump which controls jump (going up or down) and jump animations
func _jump(motion, anim, is_rotated, normal_jump, higher_jump, fall_multiplier):

	# Player is falling
	if motion.y > 50:
		anim.play("jumping_down")
		anim.set_flip_h(is_rotated)
		motion += Vector2.UP * (-9.8) * (fall_multiplier)

	elif -50 <= motion.y && motion.y <= 50:
		print("ta no meio porra")
		anim.play("jumping_mid")
		anim.set_flip_h(is_rotated)

	elif motion.y < -50 && Input.is_action_just_released("jump"): #Player is jumping
		# Higher jump
		# Jump Height depends on how long you will hold key
		anim.play("jumping_up")
		anim.set_flip_h(is_rotated)
		motion += Vector2.UP * (-9.8) * higher_jump * 2
	else:
		print(" ")
	if is_on_floor():
		# Normal jump
		anim.play("idle slim")
		if Input.is_action_just_pressed("jump"):
			anim.play("jumping_up")
			anim.set_flip_h(is_rotated)
			motion += Vector2.UP * normal_jump * 2
	return motion


# when direction key are pressed move player on the X-axis
func _move_horizontal(motion, anim, is_rotated, dir, xspeed):
	if dir == 'left':
		motion.x -= xspeed
		anim.play("walk")
		anim.set_flip_h(is_rotated)

	elif dir == 'right':
		motion.x += xspeed
		anim.play("walk")
		anim.set_flip_h(is_rotated)

	elif dir == null:
		pass
	return [motion, is_rotated, dir]
