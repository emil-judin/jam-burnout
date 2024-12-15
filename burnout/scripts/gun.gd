extends Node2D

@export var bullet_scene: PackedScene
@export var auto_shoot: bool = true
@export var auto_shoot_frequency: float = 0.2
@export var auto_shoot_timer: float

func _process(delta):
	auto_shoot_timer += delta
	if auto_shoot_timer >= auto_shoot_frequency:
		shoot()
		auto_shoot_timer = 0

func _input(event):
	if event.is_action_pressed("shoot") && !auto_shoot:
		shoot()


func shoot():
	# instantiate bullet
		var direction_to_mouse = get_global_mouse_position() - global_position
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.direction = direction_to_mouse.normalized()
		get_parent().add_child(bullet_instance)
