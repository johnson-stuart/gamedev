extends CharacterBody2D

var can_laser: bool = true
var can_grenade: bool = true

signal laser(pos, direction)
signal grenade(pos, direction)

func _process(_delta):
	
	#input
	var direction  = Input.get_vector("left", "right", "up", "down")
	velocity = direction * 500
	move_and_slide()
	
	#rotate player to look at mouse
	look_at(get_global_mouse_position())
	
	#laser shooting input
	if Input.is_action_just_pressed("primary action") and can_laser:
		#randomly select marker 2d for the laser start position
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		can_laser = false
		$LaserCooldown.start()
		var player_direction = (get_global_mouse_position() - position).normalized()
		#emit the position we selected
		laser.emit(selected_laser.global_position, player_direction)
		
		
		
	#shoot grenade
	if Input.is_action_just_pressed("secondary action") and can_grenade:
		can_grenade = false
		$GrenadeCooldown.start()
		var grenade_marker = $GrenadeStartPosition.get_children()
		var pos = grenade_marker[0].global_position
		var player_direction = (get_global_mouse_position() - position).normalized()
		grenade.emit(pos, player_direction)


func _on_laser_cooldown_timeout() -> void:
	can_laser = true


func _on_grenade_cooldown_timeout() -> void:
	can_grenade = true
