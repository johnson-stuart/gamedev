extends Area3D

@export var weapon_scene: PackedScene

var player_in_range: Node = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.has_method("equip"):
		player_in_range = body

func _on_body_exited(body: Node) -> void:
	if body == player_in_range:
		player_in_range = null

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		player_in_range.equip(weapon_scene)
		queue_free()
