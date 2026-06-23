extends CharacterBody2D


@export var speed: int = 300
@export var acceleration: int = 20
@export var jump_speed: int = -speed / 3
@export var gravity: int = speed * 0.8
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	handle_input()
	update_movement(_delta)
	update_animation()
	move_and_slide()

func handle_input() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_speed
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, acceleration)
	else: velocity.x = move_toward(velocity.x, speed * direction, acceleration)


func update_movement(_delta: float) -> void:
	velocity.y += gravity * _delta



func update_animation() -> void:
	if velocity.x == 0:
		animations.play("idle")
		return
	
	animations.scale.x = sign(velocity.x)
	animations.play("run")
