extends Node3D

@onready var hp_bar: ProgressBar = $SubViewport/hp_bar
@onready var hp_sprite: Sprite3D = $hp_bar_sprite

var max_health: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	hp_bar.value = max_health
	hp_sprite.visible = true

func _process(delta):
	return
	
