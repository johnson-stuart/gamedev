extends Area2D

@export var speed: int = 2000

var direction

func _process(delta):
	position += direction * speed * delta
