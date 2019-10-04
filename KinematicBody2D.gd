extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 10
var motion = Vector2()
var temp = 0
var direita = true
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Sprite/AnimatedSprite").set_flip_h(true)
	pass # Replace with function body.

func _physics_process(delta):
	if speed > 10:
		speed = 0
	get_node("Sprite/AnimatedSprite").play('walking')
	if temp > 300:
		temp = 0
		if direita:
			direita = false
			get_node("Sprite/AnimatedSprite").set_flip_h(false)
		else:
			direita = true
			get_node("Sprite/AnimatedSprite").set_flip_h(true)
	if direita:
		motion.x -= speed
	else:
		motion.x += speed
		
	temp += 1
	motion = move_and_slide(motion, Vector2(0,-1))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
