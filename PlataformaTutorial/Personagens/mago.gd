extends CharacterBody2D

var follow_player : bool = true
var speed : int = 20.0
var life : int = 3.0
var dead_state : bool = false
var taking_damage = false
var player_locate : int = 0
var move_direction = -1
var on_air : bool = false
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
	
	if not is_on_floor():
		velocity.y += (gravity * delta) / 1.5
		on_air = true
	else:
		on_air = false
		
	if taking_damage:
		velocity.y = -70
		velocity.x = 150 * (move_direction * -1)
	
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

	if move_direction > 0:
		animated_sprite.flip_h = false
	elif move_direction < 0:
		animated_sprite.flip_h = true


func _on_hit_box_area_entered(area):
	damage_delt()


func _on_damage_cd_timeout():
	taking_damage = false


func _on_dead_timer_timeout():
	queue_free()
	dead_state = false
