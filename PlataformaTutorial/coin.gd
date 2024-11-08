extends Area2D

@onready var player = $"../Player"
@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("Coin")


func _on_body_entered(body):
	if body.name == "Player":
		player.coin_collected()
		$"../TelaVitoria/TelaVitoria".coletar_moeda()
		queue_free()

