extends CharacterBody2D

const SPEED = 300
const MAX_JUMP_VELOCITY = -380
const ON_JUMP_VELOCITY = 150
const ACCELERATION = 500
const FRICTION = 500
var ACCUM_VELOCITY = -80
var is_jumping = false
var last_facing_direction: int = 1

var charging_jump = false
@onready var player_animation: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var input_axis = Input.get_axis("ui_left", "ui_right")
	apply_gravity(delta)
	handle_movement(delta, input_axis)
	move_and_slide()
	handle_animations(input_axis)
	

func apply_gravity(delta:float):
	if !is_on_floor():
		velocity.y += 10   
	else:
		is_jumping = false
	
	
func handle_movement(delta:float, input_axis: int):
	if !charging_jump && !is_jumping:
		if input_axis < 0 :
			velocity.x = move_toward(velocity.x, SPEED * input_axis, delta * ACCELERATION)
		elif input_axis > 0 :
			velocity.x = move_toward(velocity.x, SPEED * input_axis, delta * ACCELERATION)
		else:
			velocity.x = move_toward(velocity.x, 0, delta * FRICTION)
	
	if Input.is_action_just_pressed("ui_accept") && is_on_floor():
		velocity.x = 0
		charging_jump = true
		while ACCUM_VELOCITY >= MAX_JUMP_VELOCITY:                                                 
			await  get_tree().create_timer(0.1).timeout
			ACCUM_VELOCITY -= 50
	if Input.is_action_just_released("ui_accept"):
		#
			var normalized = Vector2(ON_JUMP_VELOCITY * input_axis,ACCUM_VELOCITY)
			velocity = lerp(velocity, normalized, 1)
			charging_jump = false
			is_jumping = true
	
	if !is_on_floor() && is_on_wall_only():
		var wall_normal = get_wall_normal()
		velocity.x = ON_JUMP_VELOCITY / 1.5 * wall_normal.x
			

func handle_animations(input_axis: int):
	last_facing_direction = input_axis
	if input_axis < 0:
		player_animation.flip_h = true
	elif input_axis > 0:     
		player_animation.flip_h = false
	else:
		last_facing_direction = -1 if last_facing_direction < 0 else 1
		
	if input_axis && !charging_jump && is_on_floor(): 
		player_animation.play("run")
	elif !input_axis || is_on_floor()  :
		player_animation.play("idle")
	
	if charging_jump:
		player_animation.play("crouch")
	
	if Input.is_action_just_released("ui_accept"):
		player_animation.play("jump")
		
	if velocity.y > 0 : 
		player_animation.play("fall") 
		
