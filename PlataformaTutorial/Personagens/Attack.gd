extends Area2D

var dir = 1
var pdir = 1
var td : bool = false
@onready var Player = $".."

func dir_player(pdir):
	if pdir == 1:
		dir = 1
	else:
		dir = 0
func _ready():
	$Attack_HitBox.disabled = true
	
func _physics_process(delta):
	if dir == 1:
		global_rotation = 0
	else:
		global_rotation = 3.15

func Attack():
	$Attack_hitbox.start()
	$Attack_timer.start()

func _on_attack_timer_timeout():
	$Attack_HitBox.disabled = true
	
func _on_attack_hitbox_timeout():
	$Attack_HitBox.disabled = false
