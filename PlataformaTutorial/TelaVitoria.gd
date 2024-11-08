extends Control
var victory_on: bool = false
var clicked: bool = false

func mandar_tempo(mins: int, secs: int, mili: int):
	$VBoxContainer/Tempo.tempo(mins, secs, mili)
	
func coletar_moeda():
	$VBoxContainer/Moedas.moedas_coletadas()


func vitoria():
	victory_on = true
	self.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().paused = true
	
func _process(delta):
	$WinnerMusic.play()
	if (Input.is_action_just_pressed("enter") or Input.is_action_just_pressed("pause")) and victory_on:
		get_tree().paused = false
		if not clicked:
			$"../../Player".winner()
			clicked = true
			get_tree().change_scene_to_file("res://MainMenu.tscn")
			victory_on = false
