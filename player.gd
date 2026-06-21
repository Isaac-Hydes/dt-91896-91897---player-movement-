extends CharacterBody2D

@export var speed: float = 300
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	handle_input()
	update_animation()
	move_and_slide()


func handle_input() -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed


func update_animation() -> void:
	if velocity.x == 0:
		animations.play("idle")
		return
	
	animations.scale.x = sign(velocity.x)
	animations.play("run")
