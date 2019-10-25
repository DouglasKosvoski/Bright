## pulo variavel
## sem animacao de pulo

extends KinematicBody2D

export (int) var jump_speed = -300   #speed of the jump
export (int) var gravity = 800  #gravity
var jump_pressed #variable that check if the jump key is keep pressed
var jump  #variable that check if the jump key is just pressed
var jump_cut # variable that check if jump button is just released
var run_speed = 1200
#direction states
var right
var left

#velocity vector
var velocity = Vector2()


func get_input():
	velocity.x = 0
	right = Input.is_action_pressed('ui_right')
	left = Input.is_action_pressed('ui_left')
	jump_pressed = Input.is_action_pressed('ui_select') #jump button is keep pressed
	jump_cut = Input.is_action_just_released('ui_select')  #jump button just released
	jump = Input.is_action_just_pressed('ui_select')   #jump button is just pressed

	if jump && is_on_floor():  # check if the jump button is just pressed and if the player is on the floor
		jump() # call jump method
	if velocity.y < 0 && !jump_pressed: # here is the deal: if the jump button is not keep pressed anymore, the y velocity is set to 0 and the player don't go up anymore
		velocity.y = 0

	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed

func jump():
    velocity.y = jump_speed

#func change_direction_sprite():
#   if right:
#       $Sprite.flip_h = false
#   elif left:
#       $Sprite.flip_h = true

func _physics_process(delta):
    get_input()
    velocity.y += gravity * delta # gravity
    velocity = move_and_slide(velocity, Vector2(0, -1))
    #change_direction_sprite()
