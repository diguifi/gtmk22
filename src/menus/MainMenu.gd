extends MarginContainer



func _on_PlayBtn_pressed():
	Transition.fade_to("res://src/levels/level1/Level1.tscn")


func _on_QuitBtn_pressed():
	get_tree().quit()
