extends CharacterBody2D


var speed = 25.0
var jump_velocity_up = -140.0
var jump_velocity_forward = 200
var move_direction = 1
var wall_cd : bool = false
var is_jumping : bool = false
var fell : bool = false
var on_air : bool = false
var taking_damage : bool = false
var life : int = 3
var dead_state : bool = false
var player_locate = 0
var follow_player : bool = false

@onready var Player = $"../Player"
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func damage_delt():
	if life == 1 and not dead_state: 
		$Dead.play()
		$Dead_timer.start()
		dead_state = true
	elif not dead_state:
		$Hurt.play()
		life -= 1
		taking_damage = true
		$Damage_CD.start()
	

func _physics_process(delta):
	
	if dead_state:
		$HitBox/CollisionShape2D.disabled = true
		velocity.x = 0
	
	if follow_player and not on_air:
		
		player_locate = (Player.position.x - position.x)
		if player_locate < 0:
			player_locate = -1
		elif player_locate > 0:
			player_locate = 1
		move_direction = player_locate	
	else:
		if is_on_wall():
			if move_direction == -1:
				position.x += 0.01
			else:
				position.x -= 0.01
			move_direction = move_direction * (-1)
		
	if is_jumping and not dead_state and not taking_damage:
		$Jump.play()
		velocity.y = jump_velocity_up
		velocity.x = jump_velocity_forward * move_direction
		
	if taking_damage:
		$JumpCD2.start(0.8)
		velocity.y = -70
		velocity.x = 150 * (move_direction * -1)
	
	if not is_on_floor():
		velocity.y += (gravity * delta) / 1.5
		on_air = true
	else:
		on_air = false
	
	
	if is_jumping or on_air or taking_damage or dead_state:
		pass
	elif is_on_floor():
		velocity.x = 0
		
	move_and_slide()
	update_animation()
	update_facing_direction()
	
func update_animation():
	if dead_state:
		animated_sprite.play("dead")
	elif on_air:
		animated_sprite.play("jump")
	else:
		animated_sprite.play("idle")
	
func update_facing_direction():
	if not dead_state:
		if move_direction > 0:
			animated_sprite.flip_h = false
		elif move_direction < 0:
			animated_sprite.flip_h = true


func _on_jump_cd_ready():
	$JumpCD.start()
	is_jumping = true


func _on_jump_cd_timeout():
	is_jumping = false
	$JumpCD2.start(1.5)
	

func _on_jump_cd_2_timeout():
	$JumpCD.start()
	is_jumping = true


func _on_area_2d_area_entered(area):
	damage_delt()


func _on_damage_cd_timeout():
	taking_damage = false


func _on_dead_timer_timeout():
	queue_free()
	dead_state = false


func _on_player_locator_area_entered(area):
	follow_player = true


func _on_player_locator_area_exited(area):
	follow_player = false
