extends Node2D
class_name FireBullet

@export var bullet_speed: float = 100
@export var lifetime: float = 10
@export var damage: int = 1
var direction: Vector2 = Vector2.ZERO
var current_lifetime: float = 0

func _ready():
	if direction == Vector2.ZERO:
		print("bullet direction not set!")
		queue_free()

func _process(delta):
	current_lifetime += delta
	if current_lifetime >= lifetime:
		queue_free()

func _physics_process(delta):
	global_position += direction.normalized() * bullet_speed

func _on_area_entered(area: Area2D):
	if area.get_parent() is not Player && area.get_parent() is not TimeItem:
		queue_free()
