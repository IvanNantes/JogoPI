extends Node2D


func _ready():
	pass 

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		$EscTimer.start()
	
func _on_esc_timer_timeout():
	$Pause/Pause.pause()
