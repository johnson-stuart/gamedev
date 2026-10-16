extends CharacterBody3D

const SPEED := 5.0
const JUMP_VELOCITY := 4.5
const ROTATION_SPEED := 10.0
const SPRING_ARM_LENGTH := 40

@export var mouse_sensitivity := 0.003
@export var tilt_limit = deg_to_rad(75)
@export var plane_height = 0.0
@export var zoom_min := 2.0
@export var zoom_max := 40.0
@export var zoom_step := 1.0
@export var zoom_smoothing := 10.0


@onready var back_socket: Node3D = $player_character/Armature/Skeleton3D/Cube_002/Cube_002/player_backsocket
@onready var hand_socket: Node3D= $player_character/Armature/Skeleton3D/Cube_016/Cube_016/player_handsocket
@onready var ability_button: Button = $HUD/AbilityButton
@onready var player_anim: AnimationPlayer = $player_character/AnimationPlayer
@onready var player_character: Node3D = $player_character
@onready var spring_arm: Node3D = $SpringArm3D
@onready var hp_bar: ProgressBar = $HUD/hp_bar
@onready var power_bar: ProgressBar = $HUD/power_bar


var orbiting := false
var weapon: Node3D
var target_position: Vector3
var target_zoom: float
var max_hp = 100
var max_power = 100
var base_power_regen_rate = 10
var power_regen_timer = 5
var in_combat := false

func plane_intersect(event: InputEvent):
	# Data
	var cam = get_viewport().get_camera_3d()
	var movement_plane = Plane(Vector3.UP, Vector3(0, plane_height, 0))
	var screen_point = event.position
			
	# Raycast Info
	var ray_normal = cam.project_ray_normal(screen_point)
	var ray_origin = cam.global_position
			
	# Intersect with plane
	var plane_point = movement_plane.intersects_ray(ray_origin, ray_normal)
	
	# Process intersection
	if plane_point:
		target_position = plane_point

func equip(scene: PackedScene) -> void:
	if weapon:
		weapon.queue_free()
	weapon = scene.instantiate()
	back_socket.add_child(weapon)
	ability_button.visible = true

func _ready() -> void:
	ability_button.visible = false
	ability_button.pressed.connect(use_ability)
	target_position = global_position
	target_zoom = SPRING_ARM_LENGTH
	hp_bar.max_value = max_hp
	power_bar.max_value = max_power

func _unhandled_input(event: InputEvent) -> void:
		
	if event.is_action_pressed("ability_1"):
		use_ability()
		
	if event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_MIDDLE:
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity
		spring_arm.rotation.x -= event.relative.y * mouse_sensitivity
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -tilt_limit, 0.0)
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = clamp(target_zoom - zoom_step, zoom_min, zoom_max)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = clamp(target_zoom + zoom_step, zoom_min, zoom_max)
	
	if event is InputEventMouse:
		if event.button_mask == MOUSE_BUTTON_LEFT and event.is_pressed() and !event.is_echo():
			plane_intersect(event)
	
	
func _physics_process(delta: float) -> void:
	
	spring_arm.spring_length = lerp(spring_arm.spring_length, target_zoom, zoom_smoothing * delta)
	
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
	
	var to_target := target_position - global_position
	to_target.y = 0.0

	if to_target.length() > 0.2:
		var dir := to_target.normalized()
		velocity.x = dir.x * SPEED
		velocity.z = dir.z * SPEED

		var target_yaw := atan2(dir.x, dir.z)
		player_character.rotation.y = lerp_angle(player_character.rotation.y, target_yaw, ROTATION_SPEED * delta)

		player_anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)
		player_anim.play("Idle")
		
	
	move_and_slide()
	
func _process(delta: float) -> void:
	if power_bar.value < 100 and !in_combat:
		power_bar.value += base_power_regen_rate*delta
	
func use_ability() -> void:
	if weapon == null:
		return
	power_bar.value -= 50
	weapon.reparent(hand_socket, false)
	
	
	
