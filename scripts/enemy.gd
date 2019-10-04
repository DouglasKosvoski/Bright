extends KinematicBody2D

var temp = 0
var speed = 400
var speed_factor = 2
var motion = Vector2()
var direita = false

func _ready():
	get_node("Sprite/AnimatedSprite").set_flip_h(direita)

func _physics_process(delta):
	var anim = get_node("Sprite/AnimatedSprite")

	anim.play('walking')

	if temp > 300:
		if direita:
			direita = false
			anim.set_flip_h(direita)

		else:
			direita = true
			anim.set_flip_h(direita)
		temp = 0
	else:
		temp += 1
	
	if direita:
		motion.x = -speed/speed_factor
	else:
		motion.x = +speed/speed_factor

	motion = move_and_slide(motion, Vector2(0,-1))
