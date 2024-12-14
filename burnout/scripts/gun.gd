extends Node2D

@export var bullet_scene: PackedScene

func _input(event):
	if event.is_action_pressed("shoot"):
		# instantiate bullet
		var direction_to_mouse = get_global_mouse_position() - global_position
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.direction = direction_to_mouse.normalized()
		get_parent().add_child(bullet_instance)
