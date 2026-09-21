extends CharacterBody3D
# Third-person controller. Hold LEFT MOUSE BUTTON and drag to turn.
# The player's body rotates left/right with the mouse, so the player always faces
# the direction the camera is looking. The camera arm handles up/down tilt.
#
# Expected scene tree (node names must match exactly):
#
# Player (CharacterBody3D)   <- this script; turns left/right (yaw)
#   CollisionShape3D
#   MeshInstance3D
#   CameraPivot (Node3D)          position (0, 1.5, 0), rotation (0, 0, 0)
#     SpringArm3D                 spring_length 4, rotation (0, 0, 0)  -> up/down (pitch)
#       Camera3D                  position (0, 0, 0), rotation (0, 0, 0)

const SPEED := 5.0
const JUMP_VELOCITY := 4.5

@export var mouse_sensitivity := 0.003
@export var min_pitch_deg := -70.0   # how far you can look down from above
@export var max_pitch_deg := 30.0    # how far you can look up from below

@onready var spring_arm: SpringArm3D = $CameraPivot/SpringArm3D

var orbiting := false


func _ready() -> void:
	# Stop the camera arm from colliding with the player's own body
	spring_arm.add_excluded_object(get_rid())


func _unhandled_input(event: InputEvent) -> void:
	# Hold left mouse button to turn. The cursor is hidden and locked while dragging,
	# then returns when you let go.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		orbiting = event.pressed
		if orbiting:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	elif event is InputEventMouseMotion and orbiting:
		# Left/right: turn the whole player (the camera is a child, so it swings around too)
		rotate_y(-event.relative.x * mouse_sensitivity)
		# Up/down: tilt the spring arm, clamped so the camera can't flip over
		spring_arm.rotation.x = clampf(
			spring_arm.rotation.x - event.relative.y * mouse_sensitivity,
			deg_to_rad(min_pitch_deg),
			deg_to_rad(max_pitch_deg)
		)


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
