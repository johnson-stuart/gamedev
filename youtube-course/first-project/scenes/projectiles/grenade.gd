extends RigidBody2D

const speed = 750

func _explode():
	$AnimationPlayer.play("explosion")
	
