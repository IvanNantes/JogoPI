extends Label

var time = 0
var timer_on: bool = false

func _ready():
	timer_on = true


func _process(delta):
	if timer_on:
		time += delta
	
	var mils = fmod(time,1)*1000
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60) / 60
	
	var time_passed = "%02d : %02d" % [mins,secs]
	text = time_passed
	$"../../TelaVitoria/TelaVitoria".mandar_tempo(mins, secs, mils)
	pass
