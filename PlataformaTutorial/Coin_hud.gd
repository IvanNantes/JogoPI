extends Sprite2D

var coins: int = 0

func coins_setup(coins):
	$coin_number.text = str(coins).pad_zeros(3)
	
func coin_update(coins):
	$coin_number.text = str(coins).pad_zeros(3)
	$AudioStreamPlayer.play()
