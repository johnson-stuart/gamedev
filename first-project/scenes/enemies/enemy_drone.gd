extends CharacterBody2D

func _process(_delta):
	
	#direction of movement
	var direction = Vector2.RIGHT
	
	#velocity
	velocity = direction*100
	
	#move and slide
	move_and_slide()
	
	
	
	
	
