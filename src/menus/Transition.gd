extends CanvasLayer

onready var animation = $AnimationPlayer
onready var debug_overlay = $DebugOverlay
onready var physics_time = $DebugOverlay/PhysicsTime
onready var node_count = $DebugOverlay/NodeCount
onready var video_mem = $DebugOverlay/VideoMem
onready var text_mem = $DebugOverlay/TextMem
export var debug = false
var path = ""

func _ready():
	if (debug):
		debug_overlay.visible = true

func fade_to(scn_path):
	self.path = scn_path
	animation.play("Fade")

func change_scene():
	if path != "":
		get_tree().change_scene(path)

func _process(delta):
	if (debug):
		physics_time.text = "phy_time:" + String(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS))
		node_count.text = "nodes:" + String(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
		video_mem.text = "video:" + String(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED))
		text_mem.text = "textu:" + String(Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED))
