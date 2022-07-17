extends Area2D

onready var tween = $Tween
onready var ray = $RayCast2D

export var speed = 3

var dir = ""
var last_value = 1
var tile_size = 64
var play_pos = Vector2(0,0)
var exit_pos = Vector2(0,0)
var on_play = true
var on_exit = false
var on_nothing = false
var inputs = {"ui_up": Vector2.UP,
			"ui_down": Vector2.DOWN}
var sides = {
	"1": {
		"ui_down": "3",
		"ui_up": "4",
	},
	"2": {
		"ui_down": "3",
		"ui_up": "4",
	},
	"3": {
		"ui_down": "6",
		"ui_up": "1",
	},
	"4": {
		"ui_down": "1",
		"ui_up": "6",
	},
	"5": {
		"ui_down": "3",
		"ui_up": "4",
	},
	"6": {
		"ui_down": "4",
		"ui_up": "3",
	}
}

func _ready():
	play_pos = global_transform.origin.y
	exit_pos = global_transform.origin.y + tile_size
	
func _process(delta):
	check_light_menu()
	if tween.is_active():
		return
	for dir_key in inputs.keys():
		if Input.is_action_pressed(dir_key):
			move(dir_key)
			
func check_light_menu():
	if global_transform.origin.y == play_pos and !on_play:
		on_play = true
		on_exit = false
		on_nothing = false
		Signals.emit_signal("light_menu", "PlayBtn")
	elif global_transform.origin.y == exit_pos and !on_exit:
		on_play = false
		on_exit = true
		on_nothing = false
		Signals.emit_signal("light_menu", "QuitBtn")
	elif global_transform.origin.y != play_pos and global_transform.origin.y != exit_pos and !on_nothing:
		on_play = false
		on_exit = false
		on_nothing = true
		Signals.emit_signal("light_menu", null)
			
func move(next_dir):
	ray.cast_to = inputs[next_dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		$AudioStreamPlayer.play()
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
