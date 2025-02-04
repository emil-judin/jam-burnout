extends CharacterBody2D
class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: CollisionShape2D = $Area2D/CollisionShape2D
@onready var gun: Gun = $Gun
@export var ui: UI
@export var stomp_scene: PackedScene
@export var movement_speed: float = 600
@export var max_health_time: float = 120
@export var start_health_time: float = 90  # seconds
@export var lingering_timeout_enemies = 1
@export var camera: Camera2D
const time_frame_length: int = 5
var health_timer: Timer = null
var survived_timer: float = 0
var is_in_puddle = false
var puddle_lingering_timeout = 0.2
var puddle_lingering_timer = 0
var current_stomp_instance = null
var is_dead: bool = false
var is_stomping: bool = false

func _ready():
	survived_timer = 0
	
	health_timer = Timer.new()
	health_timer.set_wait_time(start_health_time)
	add_child(health_timer)
	health_timer.connect("timeout", func(): _on_timer_timeout())
	ui.initialize_health_ui(start_health_time, max_health_time)
	health_timer.start()

	#$FeuerBallSound.play()

func _input(event):
	if event.is_action_pressed("stomp") && current_stomp_instance == null:
		is_stomping = true
		animated_sprite.play("stomp_complete")
		current_stomp_instance = stomp_scene.instantiate() as Stomp
		add_child(current_stomp_instance)
		current_stomp_instance.activate(self)
		subtract_health_time(current_stomp_instance.cost)
		await get_tree().create_timer(0.5).timeout
		$FireFartSound.play()
		
func _process(delta):
	survived_timer += delta
	
	if !health_timer.is_stopped():
		var time_frames_survived = int(survived_timer / time_frame_length)
		if time_frames_survived >= 1:
			survived_timer = 0
			ui.update_time_score(time_frames_survived)
		#ui.update_countdown(health_timer.time_left)
		ui.update_progress_bar(health_timer.time_left)
		
	if is_in_puddle:
		if !$ExtinguishSound.playing:
			$ExtinguishSound.play()
		if puddle_lingering_timer >= puddle_lingering_timeout:
			subtract_health_time(0.1)
			puddle_lingering_timer = 0
		else:
			puddle_lingering_timer += delta

func add_heatlth_time(seconds: float) -> void:
	if health_timer.time_left + seconds <= max_health_time:
		health_timer.start(health_timer.time_left + seconds)
	else:
		health_timer.start(max_health_time)

func subtract_health_time(seconds: float) -> void:
	if health_timer.time_left - seconds > 0:
		health_timer.start(health_timer.time_left - seconds)
	else:
		_on_timer_timeout()

func _on_timer_timeout():
	if !is_dead:
		health_timer.stop()
		ui.update_progress_bar(0)
		is_dead = true
		remove_child(gun)
		$DeathSound.play()
		animation_player.play("death")
		camera.do_death_animation()
		await get_tree().create_timer(5).timeout
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game/EndScreen.tscn")

func _physics_process(delta):
	if is_stomping:
		if !animated_sprite.is_playing():
			is_stomping = false
		return
	
	if is_dead:
		animated_sprite.play("die")
		hit_box.disabled = true
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.x > 0:
		animated_sprite.play("side_walk")
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.play("side_walk")
		animated_sprite.flip_h = true
	elif direction.y > 0:
		animated_sprite.play("front_walk")
	elif direction.y < 0:
		animated_sprite.play("back_walk")
	else:
		animated_sprite.play("idle")
	velocity = direction * movement_speed
	move_and_slide()
	
	if Input.is_action_just_pressed("+"):
		add_heatlth_time(10)
	if Input.is_action_just_pressed("-"):
		subtract_health_time(10)
	
func time_item_collected(time_value):
	add_heatlth_time(time_value)

func _on_area_entered(area: Area2D):
	var parent = area.get_parent()
	if parent is TimeItem:
		var time_item = parent as TimeItem
		#print("inceasing timer by " + str(time_item.time_value))
		time_item_collected(time_item.time_value)
		time_item.collect()
		$FireCollectSound.play()
		
	if parent is Enemy || parent is JumpingEnemy || parent is FlyingEnemy:
		# Deal contact damage
		#print("decreasing timer by " + str(parent.contact_damage))
		subtract_health_time(parent.contact_damage)
		$PlayerDamage.play()
	if parent is EnvironmentDamage:
		is_in_puddle = true
		$PlayerDamage.play()
	if parent is EnemyBullet:
		# Deal bullet damage
		var enemy_bullet = parent as EnemyBullet
		#print("decreasing timer by " + str(enemy_bullet.damage))
		subtract_health_time(enemy_bullet.damage)
		$PlayerDamage.play()

func _on_area_exited(area: Area2D):
	var parent = area.get_parent()
	if parent is EnvironmentDamage:
		is_in_puddle = false
		$PlayerDamage.play()
