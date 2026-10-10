# Cameras

The player camera is currently 3rd person behind the player, controlled by the right mouse button to pan left and right. It uses a Node3D in the player scene consisting of a SpringArm3D and a Camera3D node.

```
func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		orbiting = event.pressed
		if orbiting:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	elif event is InputEventMouseMotion and orbiting:
		rotate_y(-event.relative.x * mouse_sensitivity)
		spring_arm.rotation.x = clampf(
			spring_arm.rotation.x - event.relative.y * mouse_sensitivity,
			deg_to_rad(min_pitch_deg),
			deg_to_rad(max_pitch_deg)
		)
```

