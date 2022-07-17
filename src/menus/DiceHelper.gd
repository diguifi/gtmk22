extends Control

onready var up = $Up
onready var down = $Down
onready var left = $Left
onready var right = $Right
#onready var current = $Current

var next_sides = {
	"ui_down": "3",
	"ui_up": "4",
	"ui_right": "5",
	"ui_left": "2",
}
var current_side = "1"

func _ready():
	Signals.connect("player_moved", self, "_player_moved")
	Signals.connect("player_moving", self, "_player_moving")
	set_sides()
	
func set_sides():
	#current.set_frame(int(current_side)-1)
	up.set_frame(int(next_sides["ui_up"])-1)
	down.set_frame(int(next_sides["ui_down"])-1)
	left.set_frame(int(next_sides["ui_left"])-1)
	right.set_frame(int(next_sides["ui_right"])-1)

func _player_moved(current_received, next_sides_received):
	next_sides = next_sides_received
	current_side = current_received
	set_sides()
