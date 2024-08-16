extends Node



func _ready():
	$VBoxContainer/VBoxContainer/Jogar.grab_focus()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_jogar_pressed():
	$Select.play()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://mundo.tscn")
	

func _on_opções_pressed():
	$Select.play()

func _on_sair_pressed():
	$Select.play()	
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().quit()
	

	
	
