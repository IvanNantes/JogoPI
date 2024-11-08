extends CharacterBody2D

var speed = 15.0  # Velocidade de movimento reduzida, pois é um slime gigante
var jump_velocity_up = -200.0  # Força do pulo para cima
var jump_delay = 0.5  # Tempo no ar antes de cair no ataque
var move_direction = 1  # Direção de movimento
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking : bool = false
var on_air : bool = false
var life : int = 10  # Mais vida para o boss
var dead_state : bool = false
var player_locate = 0
var follow_player : bool = false

@onready var Player = $"../Player"
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer = $AttackTimer  # Timer para controlar o pulo de ataque
@onready var attack_cooldown = $AttackCooldown  # Timer de cooldown entre ataques

func damage_delt():
	if life <= 1 and not dead_state:
		$Dead.play()
		$Dead_timer.start()
		dead_state = true
	elif not dead_state:
		$Hurt.play()
		life -= 1
	

func _physics_process(delta):
	if dead_state:
		$HitBox/CollisionShape2D.disabled = true
		velocity.x = 0
		return
	
	# Movimentação padrão se não estiver atacando
	if follow_player and not is_attacking:
		player_locate = (Player.position.x - position.x)
		if player_locate < 0:
			player_locate = -1
		else:
			player_locate = 1
		move_direction = player_locate
		velocity.x = speed * move_direction
	
	# Pulo de ataque
	if is_attacking:
		if attack_timer.time_left > 0:  # Mantém o slime no ar por um tempo
			velocity.y = 0
		else:
			velocity.y += gravity * delta  # Queda após o delay no ar
		
	# Aplicação da gravidade quando no ar e não atacando
	if not is_on_floor() and not is_attacking:
		velocity.y += gravity * delta
		on_air = true
	else:
		on_air = false
	
	# Movimenta o slime
	move_and_slide()
	update_animation()
	update_facing_direction()

func update_animation():
	if dead_state:
		animated_sprite.play("dead")
	elif on_air:
		animated_sprite.play("jump")
	elif is_attacking:
		animated_sprite.play("attack")
	else:
		animated_sprite.play("idle")
	
func update_facing_direction():
	if move_direction > 0:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true

# Início do ataque
func start_attack():
	if not is_attacking:
		is_attacking = true
		attack_timer.start(jump_delay)
		velocity.y = jump_velocity_up  # Pulo de ataque
		$Jump.play()

# Quando o ataque termina
func _on_attack_timer_timeout():
	is_attacking = false
	attack_cooldown.start()  # Tempo para o próximo ataque

# Controle de cooldown entre ataques
func _on_attack_cooldown_timeout():
	start_attack()

# Detecta o jogador para seguir
func _on_player_locator_area_entered(area):
	follow_player = true

func _on_player_locator_area_exited(area):
	follow_player = false

# Detecta quando o slime causa dano
func _on_area_2d_area_entered(area):
	damage_delt()

# Timer de morte
func _on_dead_timer_timeout():
	queue_free()
