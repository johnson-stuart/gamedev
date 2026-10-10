extends CharacterBody3D

const SPEED := 5.0
const JUMP_VELOCITY := 4.5

@export var mouse_sensitivity := 0.003
@export var min_pitch_deg := -70.0   # how far you can look down from above
@export var max_pitch_deg := 30.0    # how far you can look up from below

@onready var spring_arm: SpringArm3D = $CameraPivot/SpringArm3D
@onready var back_socket: Node3D = $BackSocket
@onready var ability_button: Button = $HUD/AbilityButton

var orbiting := false
var weapon: Node3D

func equip(scene: PackedScene) -> void:
	if weapon:
		weapon.queue_free()
	weapon = scene.instantiate()
	back_socket.add_child(weapon)
	ability_button.visible = true


func _ready() -> void:
	# Stop the camera arm from colliding with the player's own body
	spring_arm.add_excluded_object(get_rid())
	ability_button.visible = false
	ability_button.pressed.connect(use_ability)


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
		
	if event.is_action_pressed("ability_1"):
		use_ability()


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
	
func use_ability() -> void:
	if weapon == null:
		return
	print("Slam!")  # placeholder, the real slam comes next
	
