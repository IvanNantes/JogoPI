extends TextureButton

@export var text: String = "Text button"
@export var arrow_margin_from_center: int = 100
var in_focus: bool = false

func _ready():
	setup_text()
	hide_arrows()


func setup_text():
	$Texto.bbcode_text = "[center] %s [/center]" % [text]

func show_arrows():
	for arrow in [$arrowRight, $arrowLeft]:
		arrow.visible = true
		arrow.global_position.y = global_position.y + (size.y / 2)

	var center_x = global_position.x + (size.x / 2)
	$arrowRight.global_position.x = 197.5 - arrow_margin_from_center
	$arrowLeft.global_position.x = 197.5 + arrow_margin_from_center

func hide_arrows():
	for arrow in [$arrowLeft, $arrowRight]:
		arrow.visible = false


func _on_focus_entered():
	show_arrows()
	$Texto.bbcode_text = "[center][shake rate=70.0 level=3 connected=1] %s [/shake][/center]" % [text]
	
func _on_focus_exited():
	$Pass.play()
	hide_arrows()
	$Texto.bbcode_text = "[center] %s [/center]" % [text]
