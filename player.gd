extends CharacterBody2D

#These are the variables for the code that can be changed.
@export var speed: int = 180
@export var acceleration: int = 20
@export var jump_speed: int = -speed 
@export var gravity: int = speed * 1.8
@export var down_gravity: float = 2
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var coyote_timer: Timer = $CoyoteTimer

#This is the score for the stars collection. It increases as the player collects stars. 
var score = 0

# The double jump variable.
var jump_count = 0

enum State{IDLE, WALK, JUMP, DOWN}
var current_state: State = State.IDLE

#The order of the code processes.
func _physics_process(_delta: float) -> void:
	handle_input()
	update_movement(_delta)
	update_states()
	update_animation()
	move_and_slide()

#Direction of the Player Movement taken from player input. 
func handle_input() -> void:
	# The direction of the player
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	else: velocity.x = move_toward(velocity.x, speed * direction, acceleration)

# The Gravity and Jumping of the Player
func update_movement(_delta: float) -> void:
# All of the Jumping
	
	# The second jump
	if Input.is_action_just_pressed("ui_accept") and jump_count == 1:
		velocity.y = jump_speed
		current_state = State.JUMP
		jump_count = 2
		
	# The first jump
	if (Input.is_action_just_pressed("ui_accept")) and coyote_timer.time_left > 0 and jump_buffer_timer.time_left > 0:
		velocity.y = jump_speed
		current_state = State.JUMP
		jump_buffer_timer.stop()
		coyote_timer.stop()
		jump_count = 1
		
	# When on the ground as part of the jumping code. 
	if !Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_buffer_timer.start()
		coyote_timer.start()
		jump_count = 0
		
# The Gravity of the Player
	
	# The gravity of the player
	if current_state == State.JUMP:
		velocity.y += gravity * _delta
		
	# The down gravity of the player
	else:
		velocity.y += gravity * down_gravity * _delta

# Updates and Changes the States of the player from different circumstances. 
func update_states() -> void:
	match current_state:
		State.IDLE when velocity.x != 0:
			current_state = State.WALK
	
		State.WALK:
			if velocity.x == 0:
				current_state = State.IDLE 
			if not is_on_floor() && velocity.y > 0:
				current_state = State.DOWN
		
		State.JUMP when velocity.y > 0:
			current_state = State.DOWN
			
		State.DOWN when is_on_floor():
			if velocity.x == 0:
				current_state = State.IDLE
			else:
				current_state = State.WALK
			

# This flips the player animation from left to right depending on the direction that it is moving.
func update_animation() -> void:
	if velocity.x != 0:
		animations.scale.x = sign(velocity.x)		
	
	# This is the code that plays the animations in each state. 
	match current_state:
		State.IDLE: animations.play("idle")
		State.WALK: animations.play("run")
		State.JUMP: animations.play("death")
		State.DOWN: animations.play("loselife")
	
