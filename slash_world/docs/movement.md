# Movement

## Player Movement

The player moves with WASD and jumps with Spacebar

Movement is programmed in ``player.gd``

```
func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement is relative to the direction the player is facing
	var input_dir := Input.get_vector("move_backward","move_forward", "move_left", "move_right" )
	var direction := (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)

	move_and_slide()
```

# Notes

- I might change movement to left mouse to move and leave the keyboard to use abilities. 