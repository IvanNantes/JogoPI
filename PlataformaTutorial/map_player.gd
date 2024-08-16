extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
func _physics_process(delta):
	
	if Input.is_action_pressed("up"):
		position.y -= 1.5
		animated_sprite.play("default")
	elif Input.is_action_pressed("down"):
		position.y += 1.5
	
	
	

	
