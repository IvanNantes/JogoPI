extends Sprite2D

var vida : int = 5

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D


func dano_tomado(vida):

	if vida == 5:
		animated_sprite.play("5")
	elif vida == 4:
		animated_sprite.play("4")
	elif vida == 3:
		animated_sprite.play("3")
	elif vida == 2:
		animated_sprite.play("2")
	elif vida == 1:
		animated_sprite.play("1")
	else:
		animated_sprite.play("0")
