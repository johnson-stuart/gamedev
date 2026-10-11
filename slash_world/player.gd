extends CharacterBody3D

const SPEED := 5.0
const JUMP_VELOCITY := 4.5

@export var mouse_sensitivity := 0.003
@export var tilt_limit = deg_to_rad(75)

@onready var back_socket: Node3D = $player_backsocket
@onready var hand_socket: Node3D= $player_handsocket
@onready var ability_button: Button = $HUD/AbilityButton
@onready var player_anim: AnimationPlayer = $player_character/AnimationPlayer

var orbiting := false
var weapon: Node3D

func equip(scene: PackedScene) -> void:
	if weapon:
		weapon.queue_free()
	weapon = scene.instantiate()
	back_socket.add_child(weapon)
	ability_button.visible = true


func _ready() -> void:
	ability_button.visible = false
	ability_button.pressed.connect(use_ability)


func _unhandled_input(event: InputEvent) -> void:
		
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
		player_anim.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)
		player_anim.stop()

	move_and_slide()
	
func use_ability() -> void:
	if weapon == null:
		return
	weapon.reparent(hand_socket, false)
	
