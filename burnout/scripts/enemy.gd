extends CharacterBody2D
class_name Enemy

@onready var health_manager: HealthManager = $HealthManager
@export var movemenent_speed: float = 10
var target: Node2D
var is_chasing = false

func _physics_process(delta):
	if is_chasing && target != null:
		var direction = target.global_position - global_position
		velocity = direction * movemenent_speed * delta
		move_and_slide()
	
func start_chase():
	is_chasing = true

func _on_area_entered(area: Area2D):
	if area.get_parent() is FireBullet:
		var bullet = area.get_parent() as FireBullet
		health_manager.receive_damage(bullet.damage)

func die():
	queue_free()