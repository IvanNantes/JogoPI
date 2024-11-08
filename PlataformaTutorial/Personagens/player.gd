extends CharacterBody2D


@export var speed : float = 150.0
@export var jump_velocity : float = -310.0
@export var double_jump_velocity : float = -200.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var life_hud = $"../HUD/Panel/vida"
@onready var coin_hud = $"../HUD/Coin_hud"
@onready var tela_vitoria = $"../TelaVitoria/TelaVitoria"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var had_jumped : float = 0
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var in_air : bool = false
var in_double_jump : bool = false
var in_roll : bool = false
var rollCD : bool = false
var in_dive : bool = false
var diveroll : bool = false
var coyote : bool = false
var dir_diveroll : float = 0
var is_attacking : bool = false
var attack_cd : bool = false
var is_immune : bool = false
var life = 5
var taking_damage : bool = false
var enemy_dir : int = 0
var damage_knockback : bool = false
var td : bool = false
var attack_clickoncd : bool = false
var change_dir_air: bool = false
var coins: int = 0
var win: bool = false



func _ready():
	coin_hud.coins_setup(coins)
	win = false
	animation_locked = false

func winner():
	win = true
	velocity.x = 0
	animation_locked = true

func damage_delt():
	if life > 1:
		life -=1
		life_hud.dano_tomado(life)
		$HitSound.play()
	else:
		$DeadSound.play()
		life = 0
		life_hud.dano_tomado(life)
		TransitionScreen.transition()
		
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://game_over.tscn")

func coin_collected():
	if coins < 999:
		coins += 1
		coin_hud.coin_update(coins)
		

func _physics_process(delta):
	
	if is_immune:
		$HurtBox/CollisionShape2D.disabled = true
	else:
		$HurtBox/CollisionShape2D.disabled = false
	
	if damage_knockback:
		velocity.y = -100
		velocity.x = 150 * (enemy_dir * -1)
	
	if velocity.y > 0 or velocity.y < 0: 
		set_floor_snap_length(0) 
	else: 
		set_floor_snap_length(5)
		
	if not is_on_floor():
		in_air = true
		if velocity.y == 20:
			pass
		else:
			velocity.y += (gravity * delta)
	else:
		if velocity.x == 0:
			speed = 0
		in_air = false
		had_jumped = 0
		in_double_jump = false
		if in_dive:
			in_dive = false
			diveroll = true
			velocity.x = dir_diveroll * 180
			$DiveTime.start()
			$SpinSound.play()
		coyote = false
		if taking_damage and not damage_knockback:
			velocity.x = 0
			taking_damage = false
			$ImmuneCD.start()
			$ImmuneAnimation.start()
		change_dir_air = false

	if not win:	
		if Input.is_action_just_pressed("roll") and velocity.x !=0 and not taking_damage:
			if is_on_floor() and rollCD == false and not in_dive and not diveroll:
				in_roll = true
				rollCD = true
				$SpinSound.play()
				$RollTime.start()
				$RollCD.start()
				if direction.x > 0:
					velocity.x = 180
				else:
					velocity.x = -180
				
			elif not in_dive and not diveroll and not rollCD and ( Input.is_action_pressed("left") or  Input.is_action_pressed("right")):
				in_dive = true
				$JumpSound.play()
				velocity.y = -150
				if direction.x > 0:
					velocity.x = 200
				else:
					velocity.x = -200
				dir_diveroll = direction.x

		if Input.is_action_just_pressed("jump") and not in_roll and not in_dive and not diveroll and not taking_damage:
				if had_jumped == 0:
					velocity.y = jump_velocity
					had_jumped = 1
					$JumpSound.play()
					
				elif had_jumped == 1:
					in_double_jump = true
					velocity.y = double_jump_velocity
					had_jumped = 2
					$SpinSound.play()
		
		if Input.is_action_just_released("jump") and not in_roll and not in_dive and not diveroll:
			if velocity.y < -180:
				velocity.y = -180
				
		if had_jumped == 0 and not is_on_floor() and coyote == false:
			$CoyoteJump.start()
			coyote = true
		if Input.is_action_pressed("up"):
			if $"../Camera2D".offset.y > -40:
				$"../Camera2D".offset.y -= 4
			else:
				$"../Camera2D".offset.y = -40
		else:
			if $"../Camera2D".offset.y < 0:
					$"../Camera2D".offset.y += 4
			else:
				$"../Camera2D".offset.y = 0
			
		direction = Input.get_vector("left", "right", "up", "down")
		if in_roll or in_dive or diveroll or taking_damage or life <= 0:
			pass
		elif direction.y < -0.50 and direction.y > -0.95:
			if direction.x > 0:
				if velocity.x >= 120:
					velocity.x += -10
				else:
					velocity.x += 10
			elif direction.x < 0:
				if velocity.x <= -120:
					velocity.x += 10
				else:
					velocity.x += -10
		elif direction.y < -0.95:
			if velocity.x > 0:
				if velocity.x > 0:
					velocity.x += - 20
			else:
				if velocity.x < 0:
					velocity.x += 20
		elif direction.y > 0.80:
			if velocity.x > 0:
				if velocity.x > 0:
					velocity.x += - 3.5
			else:
				if velocity.x < 0:
					velocity.x += 3.5
		elif direction:
			if direction.x > 0:
				if velocity.x >= 160:
					velocity.x = 160
				else:
					velocity.x += 20
			elif direction.x < 0:
				if velocity.x <= -160:
					velocity.x = -160
				else:
					velocity.x += -20
		elif in_air:
			if velocity.x > 0:
				if velocity.x > 0:
					velocity.x = velocity.x - 3
			else:
				if velocity.x < 0:
					velocity.x = velocity.x + 3
		elif direction.x <= 0.4 and direction.x >= -0.4:
			if velocity.x > 0:
				velocity.x += -20
				if velocity.x < 0:
					velocity.x = 0
			elif velocity.x < 0:
				velocity.x += 20
				if velocity.x > 0:
					velocity.x = 0	
			
		
		
		if (Input.is_action_just_pressed("attack") or attack_clickoncd) and not in_dive and not in_roll and not diveroll and not taking_damage and not in_double_jump:
			if attack_cd and not attack_clickoncd:
				attack_clickoncd = true
				$ClickonCD.start()
			elif attack_cd:
				pass
			else:
				$AttackSound.play()			
				$Attack.Attack()
				$AttackCD.start()
				is_attacking = true
				attack_cd = true
		
	
	move_and_slide()
	update_animation()
	update_facing_direction()
	
func update_animation():
	if not animation_locked:
		if life == 0 and is_on_floor():
			animated_sprite.play("dead")
		elif taking_damage:
			animated_sprite.play("damage")
		elif in_dive:
			animated_sprite.play("dive")
		elif diveroll:
			animated_sprite.play("diveroll")
		elif in_roll:
			animated_sprite.play("roll")
		elif is_attacking:
			animated_sprite.play("attackside")
		elif in_air == true:
			if not in_double_jump == true:
				animated_sprite.play("jump")
			else:
				animated_sprite.play("doublejump")
		elif direction.x != 0 and (direction.y < 0.80):
			if Input.is_action_pressed("up"):
				animated_sprite.play("walkUp")
				if $WalkSound.is_playing():
					pass
				else:
					$WalkSound.play()
			else:
				animated_sprite.play("walk")
				if $WalkSound.is_playing():
					pass
				else:
					$WalkSound.play()
		elif direction.y > 0.80:
			animated_sprite.play("down")
		else: 
			if Input.is_action_pressed("up"):
				animated_sprite.play("idleUp")
			else:
				animated_sprite.play("idle")
				

func update_facing_direction():
	if in_dive or is_attacking or taking_damage or life <= 0:
		pass
	elif direction.x > 0:
		$Attack.dir_player(1)
		animated_sprite.flip_h = false
	elif direction.x < 0:
		$Attack.dir_player(2)
		animated_sprite.flip_h = true



func _on_roll_time_timeout():
	in_roll = false

func _on_roll_cd_timeout():
	rollCD = false

func _on_dive_time_timeout():
	diveroll = false

func _on_coyote_jump_timeout():
	had_jumped = 1
	
func _on_attack_timer_timeout():
	is_attacking = false

func _on_attack_cd_timeout():
	attack_cd = false

func _on_hurt_box_area_entered(area):
	if area.name == "Espinhos":
		if velocity.x > 0:
				enemy_dir = 1
		elif velocity.x < 0:
			enemy_dir = -1
		elif direction.x > 0:
			enemy_dir = 1
		elif direction.x < 0:
			enemy_dir = -1
		else:
			enemy_dir = 1
		taking_damage = true
		damage_knockback = true
		$DamageJump.start()
		is_immune = true
		life = 0
		life_hud.dano_tomado(life)
		TransitionScreen.transition()
		$DeadSound.play()
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://game_over.tscn")
	elif area.name == "Vitoria":
		tela_vitoria.vitoria()
	else:
		if not in_roll and not diveroll:
			enemy_dir = (area.get_parent().position.x - position.x)
			if enemy_dir > 0:
				enemy_dir = 1
			elif enemy_dir < 0:
				enemy_dir = -1
			else:
				enemy_dir = 1
			taking_damage = true
			damage_knockback = true
			$DamageJump.start()
			is_immune = true
			damage_delt()


func _on_damage_jump_timeout():
	damage_knockback = false



func _on_immune_cd_timeout():
	is_immune = false
	$ImmuneAnimation.stop()
	$AnimatedSprite2D.visible = true

func _on_immune_animation_timeout():
	if is_immune and $AnimatedSprite2D.visible == false:
		$AnimatedSprite2D.visible = true
	elif is_immune and life != 0:
		$AnimatedSprite2D.visible = false

func _on_clickon_cd_timeout():
	attack_clickoncd = false
