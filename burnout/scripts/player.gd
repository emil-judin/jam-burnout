extends CharacterBody2D
class_name Player

@export var movement_speed: float = 400

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	# TODO: choose animation
	velocity = direction * movement_speed
	move_and_slide()
	
