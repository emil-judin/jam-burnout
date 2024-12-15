extends CharacterBody2D
class_name JumpingEnemy

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_manager: HealthManager = $HealthManager
@export var jump_range: float = 2
@export var jump_speed: float = 10
@export var jump_height: float = 5
@export var jump_delay: float = 1
@export var contact_damage: float = 1
var jump_start: Vector2
var jump_target: Vector2
var target: Node2D
var is_chasing = false
var is_jumping = false
var is_waiting = true
var jump_progress = 0
var waiting_timer = 0

func _physics_process(delta):
	if is_chasing && target != null:
		if is_waiting:
			animated_sprite.play("idle")
			if waiting_timer >= jump_delay:
				waiting_timer = 0
				jump_progress = 0
				is_waiting = false
				is_jumping = true
				
				# set new jump position
				animated_sprite.play("jump_start")
				$SpiderJump.play()
				jump_start = global_position
				var jump_to_target_position = target.position - jump_start
				if jump_to_target_position.length() <= jump_range:
					jump_target = target.global_position
				else:
					jump_target = jump_start + jump_to_target_position.normalized() * jump_range
			else:
				waiting_timer += delta
				return
		
		if is_jumping:
			if jump_progress >= 1:
				jump_progress = 0
				waiting_timer = 0
				is_jumping = false
				is_waiting = true
				animated_sprite.play("jump_end")
				return
		
		animated_sprite.play("air")
		var jump_direction = (jump_target - jump_start).normalized()
		var x = jump_direction.x
		var hypo = jump_direction.length()
		var absolute_angle = abs(asin(x/hypo))
		var jump_angle: float
		if jump_start.x <= jump_target.x && jump_start.y <= jump_target.y:
			#print("1")
			jump_angle = 3*PI/2
		elif jump_start.x <= jump_target.x && jump_start.y >= jump_target.y:
			#print("2")
			jump_angle = 3*PI/2
		elif jump_start.x >= jump_target.x && jump_start.y <= jump_target.y:
			#print("3")
			jump_angle = PI/2
		elif jump_start.x >= jump_target.x && jump_start.y >= jump_target.y:
			#print("4")
			jump_angle = PI/2
		else:
			print("huh?")
			
		var orthognal = jump_direction.rotated(jump_angle)
		var mid_point = jump_start + 0.5 * (jump_target - jump_start)
		var jump_arc_max = mid_point + orthognal * jump_height * absolute_angle
		jump(jump_start, jump_arc_max, jump_target, jump_progress)
		jump_progress += delta
	
func start_chase():
	is_chasing = true

func jump(start: Vector2, top: Vector2, end: Vector2, t: float):
	# quadratic bezier
	var q0 = start.lerp(top, t)
	var q1 = top.lerp(end, t)
	var r = q0.lerp(q1, t)
	
	global_position = r

func _on_area_entered(area: Area2D):
	if area.get_parent() is FireBullet:
		var bullet = area.get_parent() as FireBullet
		health_manager.receive_damage(bullet.damage)
		$EnemyHit.play()

func die():
	queue_free()
