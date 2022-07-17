extends Node2D

onready var area = $Area2D
onready var label = $Label
export var win_side = "1"
var can_win = false

func _ready():
	Signals.connect("player_moved", self, "_player_moved")
	label.text = win_side

func _player_moved(current_received, next_sides_received):
	var player_inside = area.get_overlapping_areas().size() > 0
	if current_received == win_side and player_inside:
		label.text = 'NICE'
		can_win = true
		Signals.emit_signal("check_win")
