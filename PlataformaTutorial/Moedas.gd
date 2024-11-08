extends Label
var total_coletado: int

func moedas_coletadas():
	total_coletado += 1
	$"../../Nota".moedas_coletadas(total_coletado)
	pass


func _process(delta):
	text = "Moedas: %s / 100" % [total_coletado]
