extends Node3D

@onready var hp_bar: ProgressBar = $hp_bar

var max_health: float = 100
var camera: Camera3D
var hp_bar_offset = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Get the active camera
	camera = get_viewport().get_camera_3d()
	hp_bar.value = max_health

func _process(delta):
	
	var screen_pos = camera.unproject_position(global_position + hp_bar_offset) 
	hp_bar.position = screen_pos
