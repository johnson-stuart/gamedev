# Equipping Weapons

Equipping objects uses a weapon_pickup.gd script and a function in player.gd

## weapon_pickup.gd

```
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
```
### Key elements

``@export var weapon_scene: PackedScene``
This takes the weapon scene (a separate scene of just the weapon) and allows it to be sent to the equip function.

``queue_free()``
Deletes the sword node from the world after it's equipped.

## player.gd

```func equip(scene: PackedScene) -> void:
	if weapon:
		weapon.queue_free()
	weapon = scene.instantiate()
	back_socket.add_child(weapon)
	ability_button.visible = true
```
### Key elements

`` if weapon: weapon.queue_free() ``
Deletes an already existing weapon.

``weapon = scene.instantiate()
	back_socket.add_child(weapon)``
Creates the scene received in the equip() call and then adds it to the chosen socket, in this case back.

## Notes

- For other weapon types or armour, I'll need other sockets - head, hand socket, hip socket etc. 
- For more weapons, I'll have to rework this since I don't want to keep creating new pickup scripts for every weapon. It should be 
a universal weapon_pickup.gd that checks the type of weapon and then sends that weapon.tscn and the weapon type to player.equip(). Then player.equip() can determine based on the weapon type which socket to use.
- If I want to implement an inventory, then the UI will have to call this equip function somehow.

# Roadmap

