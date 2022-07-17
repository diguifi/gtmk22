extends Node2D

export var next_level = ""

func _ready():
	Signals.connect("check_win", self, "_check_win")
	
func _input(ev):
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()

func _check_win():
	var can_win = true
	var checkers_on_level = get_tree().get_nodes_in_group("checkers")
	for checker in checkers_on_level:
		if !checker.can_win:
			can_win = false
	
	if can_win:
		go_to_next_level()

func go_to_next_level():
	if next_level:
		Transition.fade_to(next_level)
	else:
		Transition.fade_to("res://src/menus/End.tscn")
