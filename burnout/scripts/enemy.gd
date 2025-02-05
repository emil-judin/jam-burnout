extends CharacterBody2D
class_name Enemy

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var health_manager: HealthManager = $HealthManager
@export var movemenent_speed: float = 10
@export var contact_damage: float = 1
@export var points: int = 50
var target: Node2D
var is_chasing = false

func _ready():
	animation_player.play("spawn")

func _process(delta):
	animated_sprite.play("walk")

func _physics_process(delta):
	if is_chasing && target != null:
		var direction = target.global_position - global_position
		velocity = direction * movemenent_speed * delta
		move_and_slide()
		animated_sprite.flip_h = velocity.x < 0
	
func start_chase():
	is_chasing = true

func _on_area_entered(area: Area2D):
	if area.get_parent() is FireBullet:
		var bullet = area.get_parent() as FireBullet
		if animation_player.current_animation != "spawn":
			animation_player.play("damage")
		health_manager.receive_damage(bullet.damage)
		$EnemyDamageSound.play()

func _on_body_entererd(body: Node2D):
	if body.get_parent() is Stomp:
		if animation_player.current_animation != "spawn":
			animation_player.play("damage")
		var stomp = body.get_parent() as Stomp
		health_manager.receive_damage(stomp.damage)

func die():
	UI.current_score += points
	queue_free()
