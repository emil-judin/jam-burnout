extends CharacterBody2D
class_name FlyingEnemy

@onready var animated_sprite = $AnimatedSprite2D
@onready var health_manager: HealthManager = $HealthManager
@export var enemy_bullet_scene: PackedScene
@export var movemenent_speed: float = 10
@export var contact_damage: float = 1
@export var shoot_frequency = 1
var target: Node2D
var is_chasing = false
var shoot_timer: float

func _process(delta):
	animated_sprite.play("walk")
	if shoot_timer >= shoot_frequency:
		# TODO: also check in range
		shoot()
		shoot_timer = 0
	else:
		shoot_timer += delta

func _physics_process(delta):
	if is_chasing && target != null:
		var direction = target.global_position - global_position
		velocity = direction * movemenent_speed * delta
		move_and_slide()
		animated_sprite.flip_h = velocity.x > 0
	
func start_chase():
	is_chasing = true

func shoot():
	var enemy_bullet_instance = enemy_bullet_scene.instantiate() as EnemyBullet
	enemy_bullet_instance.direction = target.global_position - global_position
	enemy_bullet_instance.global_position = global_position
	get_parent().add_child(enemy_bullet_instance)
	$FlyEnemyShoot.play()

func _on_area_entered(area: Area2D):
	if area.get_parent() is FireBullet:
		var bullet = area.get_parent() as FireBullet
		health_manager.receive_damage(bullet.damage)
	if area.get_parent() is Stomp:
			var stomp = area.get_parent() as Stomp
			health_manager.receive_damage(stomp.damage)
			
		$EnemyHit.play()

func die():
	queue_free()
