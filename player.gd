extends CharacterBody2D


@export var speed: int = 300
@export var acceleration: int = 20
@export var jump_speed: int = -speed / 2
@export var gravity: int = speed * 0.9
@export var down_gravity: float = 0.1
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

enum State{IDLE, WALK, JUMP, DOWN}
var current_state: State = State.IDLE


func _physics_process(_delta: float) -> void:
	handle_input()
	update_movement(_delta)
	update_states()
	update_animation()
	move_and_slide()

func handle_input() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_speed
		current_state = State.JUMP
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	else: velocity.x = move_toward(velocity.x, speed * direction, acceleration)


func update_movement(_delta: float) -> void:
	if current_state == State.JUMP:
		velocity.y += gravity * _delta
	else:
		velocity.y += gravity * down_gravity


func update_states() -> void:
	match current_state:
		State.IDLE when velocity.x != 0:
			current_state = State.WALK
	
		State.WALK:
			if velocity.x == 0:
				current_state = State.WALK
			if not is_on_floor() && velocity.y > 0:
				current_state = State.DOWN
		
		State.JUMP when velocity.y > 0:
			current_state = State.DOWN
			
		State.DOWN when is_on_floor():
			if velocity.x == 0:
				current_state = State.IDLE
			else:
				current_state = State.WALK
			

func update_animation() -> void:
	if velocity.x != 0:
		animations.scale.x = sign(velocity.x)		
	
	match current_state:
		State.IDLE: animations.play("idle")
		State.WALK: animations.play("run")
		State.JUMP: animations.play("death")
		State.DOWN: animations.play("loselife")
	
	animations.play("run")
