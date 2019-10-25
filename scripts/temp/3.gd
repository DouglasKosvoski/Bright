## promissor

## pulo variavel
## boa animacao de pulo (mid parece faltar)

extends KinematicBody2D


export var fall_multiplier = 3
export var higher_jump = 30
export var normal_jump = 800
onready var anim = get_node("Sprite/AnimatedSprite")



var motion = Vector2()
export var gravity = 20

func _physics_process(delta):

	motion.y += gravity
	motion = _jump(motion, anim, normal_jump, higher_jump, fall_multiplier)
	motion = move_and_slide(motion, Vector2(0,-1))


func _jump(motion, anim, normal_jump, higher_jump, fall_multiplier):
	# Player is falling
	if motion.y > 0:
		anim.play("jumping_down")
		motion += Vector2.UP * (-9.8) * (fall_multiplier)

	elif motion.y == 0:
		anim.play("jump_middle")

	elif motion.y < 0 && Input.is_action_just_released("jump"): #Player is jumping
		# Higher jump
		# Jump Height depends on how long you will hold key
		anim.play("jumping_up")
		motion += Vector2.UP * (-9.8) * (higher_jump)

	if is_on_floor():
		anim.play("idle slim")
		# Normal jump
		if Input.is_action_just_pressed("jump"):
			anim.play("jumping_up")
			motion = Vector2.UP * normal_jump
	return motion
