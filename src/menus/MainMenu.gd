extends MarginContainer

onready var play_btn = $HBoxContainer/VBoxContainer/MenuOptions/PlayBtn/Label
onready var exit_btn = $HBoxContainer/VBoxContainer/MenuOptions/QuitBtn/Label
var play_selected = true
var quit_selected = false

func _ready():
	Signals.connect("light_menu", self, "_light_menu")
	
func _input(ev):
	if Input.is_key_pressed(KEY_SPACE):
		if play_selected:
			_on_PlayBtn_pressed()
		elif quit_selected:
			_on_QuitBtn_pressed()
	
func _physics_process(delta):
	if play_selected:
		play_btn.text = "[ Play ]"
		exit_btn.text = "Exit"
	elif quit_selected:
		exit_btn.text = "[ Exit ]"
		play_btn.text = "Play"
	else:
		play_btn.text = "Play"
		exit_btn.text = "Exit"
	
func _light_menu(node_name):
	if node_name == "PlayBtn":
		play_selected = true
		quit_selected = false
	elif node_name == "QuitBtn":
		play_selected = false
		quit_selected = true
	else:
		play_selected = false
		quit_selected = false
		

func _on_PlayBtn_pressed():
	$AudioStreamPlayer.play()
	Transition.fade_to("res://src/levels/level1/Level.tscn")


func _on_QuitBtn_pressed():
	get_tree().quit()
