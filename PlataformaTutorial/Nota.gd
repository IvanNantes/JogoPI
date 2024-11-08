extends Label
var total_moedas : int = 100
var moedas : int
var tempo : int
var moedas_porcento : float



func moedas_coletadas(moedas_col : int):
	moedas = moedas_col
	pass
	
func tempo_passado(minutos : int):
	tempo = minutos
	pass

func _process(delta):
	moedas_porcento = (100 / total_moedas) * moedas
	if moedas_porcento == 100 and tempo < 2:
		text = "S"
	elif moedas_porcento > 80 and tempo < 3:
		text = "A"
	elif moedas_porcento > 60:
		text = "B"
	elif moedas_porcento > 40:
		text = "C"
	else:
		text = "D"
	
