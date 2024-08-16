extends Node



func _ready():
	$"VBoxContainer/Reiniciar fase".grab_focus()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN



func _on_sair_pressed():
	$Select.play()	
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().quit()


func _on_reiniciar_fase_pressed():
	$Select.play()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://mundo.tscn")
	

func _on_menu_pressed():
	$Select.play()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://MainMenu.tscn")
