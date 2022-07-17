extends Area2D

onready var tween = $Tween
onready var ray = $RayCast2D

export var speed = 3

var dir = ""
var last_value = 1
var tile_size = 64
var inputs = {"ui_right": Vector2.RIGHT,
			"ui_left": Vector2.LEFT,
			"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}
var sides = {
	"1": {
		"ui_down": "3",
		"ui_up": "4",
		"ui_right": "5",
		"ui_left": "2",
	},
	"2": {
		"ui_down": "3",
		"ui_up": "4",
		"ui_right": "1",
		"ui_left": "6",
	},
	"3": {
		"ui_down": "6",
		"ui_up": "1",
		"ui_right": "5",
		"ui_left": "2",
	},
	"4": {
		"ui_down": "1",
		"ui_up": "6",
		"ui_right": "5",
		"ui_left": "2",
	},
	"5": {
		"ui_down": "3",
		"ui_up": "4",
		"ui_right": "6",
		"ui_left": "1",
	},
	"6": {
		"ui_down": "4",
		"ui_up": "3",
		"ui_right": "2",
		"ui_left": "5",
	}
}
	
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	
func _process(delta):
	if tween.is_active():
		return
	for dir_key in inputs.keys():
		if Input.is_action_pressed(dir_key):
			move(dir_key)
			
func move(next_dir):
	ray.cast_to = inputs[next_dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		dir = next_dir
		Signals.emit_signal("player_moving", dir)
		move_tween(inputs[dir])
		
func move_tween(dir_input):
	tween.interpolate_property(self, "position",
		position, position + dir_input * tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
func get_next_dice_frame(dir_move):
	var next_side = sides[String($Sprite.frame + 1)][dir_move]
	Signals.emit_signal("player_moved", next_side, sides[next_side])
	return int(next_side) - 1

func _on_Tween_tween_completed(object, key):
	$Sprite.set_frame(get_next_dice_frame(dir))
