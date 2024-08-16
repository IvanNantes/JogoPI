extends Control


func pause():
	self.visible = true
	$VBoxContainer/Continuar.grab_focus()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().paused = true
	$Select.play()

func _on_continuar_pressed():
	$Select.play()
	await get_tree().create_timer(0.40).timeout
	$".".visible = false
	get_tree().paused = false

	
func _on_sair_pressed():
	$Select.play()
	await get_tree().create_timer(0.40).timeout
	get_tree().quit()
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		_on_continuar_pressed()
	
