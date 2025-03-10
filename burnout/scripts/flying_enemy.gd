extends CharacterBody2D
class_name FlyingEnemy

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var health_manager: HealthManager = $HealthManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var enemy_bullet_scene: PackedScene
@export var movemenent_speed: float = 10000
@export var contact_damage: float = 1
@export var shoot_frequency = 1
@export var points: int = 50
var target: Node2D
var is_chasing = false
var shoot_timer: float

func _ready():
	animation_player.play("spawn")

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
		navigation_agent_2d.target_position = target.global_position
		
		if navigation_agent_2d.is_navigation_finished():
			return
		
		var current_position = global_position
		var next_position = navigation_agent_2d.get_next_path_position()
		velocity = current_position.direction_to(next_position) * movemenent_speed * delta
		
		move_and_slide()
		animated_sprite.flip_h = velocity.x > 0
	
func start_chase():
	is_chasing = true

func shoot():
	var enemy_bullet_instance = enemy_bullet_scene.instantiate() as EnemyBullet
	enemy_bullet_instance.direction = target.global_position - global_position
	enemy_bullet_instance.global_position = global_position
	get_parent().add_child(enemy_bullet_instance)
	#$FlyEnemyShoot.play()

func _on_area_entered(area: Area2D):
	if area.get_parent() is FireBullet:
		var bullet = area.get_parent() as FireBullet
		if animation_player.current_animation != "spawn":
			animation_player.play("damage")
		health_manager.receive_damage(bullet.damage)
		$EnemyHit.play()
			
func _on_body_entererd(body: Node2D):
	if body.get_parent() is Stomp:
		if animation_player.current_animation != "spawn":
			animation_player.play("damage")
		var stomp = body.get_parent() as Stomp
		health_manager.receive_damage(stomp.damage)

func die():
	UI.current_score += points
	queue_free()
