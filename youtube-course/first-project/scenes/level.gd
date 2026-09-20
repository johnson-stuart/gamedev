extends Node2D

var laser_scene = preload("res://scenes/projectiles/laser.tscn")
var grenade_scene = preload("res://scenes/projectiles/grenade.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	return
	
func _on_gate_player_entered_gate(body) -> void:
	print(body)

func _on_player_laser(pos, direction) -> void:
	var laser = laser_scene.instantiate() as Area2D
	#1 update the laser position
	laser.position = pos
	laser.rotation_degrees = rad_to_deg(direction.angle()) +90
	laser.direction = direction
	# add laser intance to Node2D
	$Projectiles.add_child(laser)
	
func _on_player_grenade(pos, direction) -> void:
	var grenade = grenade_scene.instantiate() as RigidBody2D
	grenade.position = pos
	grenade.linear_velocity = direction * grenade.speed
	$Projectiles.add_child(grenade)
