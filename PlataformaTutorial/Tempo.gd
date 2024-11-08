extends Label
var mins: int
var secs: int
var mili: int




var time_passed = "%02d : %02d : %03d" % [mins,secs,mili]

func tempo(mins: int, secs: int, mili: int):
	time_passed = "%02d : %02d : %03d" % [mins,secs,mili]
	$"../../Nota".tempo_passado(mins)
	pass
	
func _process(delta):
	text = "Tempo: %s" % [time_passed]

