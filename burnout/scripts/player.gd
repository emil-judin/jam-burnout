extends CharacterBody2D
class_name Player

signal received_damage(damage: float)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_animation: AnimationPlayer = $DamageAnimation
@onready var hit_box: CollisionShape2D = $Area2D/CollisionShape2D
@onready var gun: Gun = $Gun
@export var ui: UI
@export var stomp_scene: PackedScene
@export var movement_speed: float = 600
@export var max_health_time: float = 120
@export var start_health_time: float = 90  # seconds
@export var fart_cooldown: float = 5
@export var fart_invincibility: float = 1
@export var lingering_timeout_enemies = 1
@export var camera: Camera2D

const time_frame_length: int = 5

var health_timer: Timer = null
var survived_timer: float = 0
var fart_timer: Timer
var fart_useable: bool = true
var invincibility_timer: Timer
var invincible: bool = false
var is_in_puddle = false
var puddle_lingering_timeout = 0.2
var puddle_lingering_timer = 0
var current_stomp_instance = null
var is_dead: bool = false
var is_stomping: bool = false
var activated_stomp_hitbox: bool = false

func _ready():
	survived_timer = 0
	
	health_timer = Timer.new()
	health_timer.set_wait_time(start_health_time)
	add_child(health_timer)
	health_timer.connect("timeout", func(): _on_timer_timeout())
	ui.initialize_health_ui(start_health_time, max_health_time)
	health_timer.start()
	fart_timer = Timer.new()
	add_child(fart_timer)
	fart_timer.connect("timeout", func(): _on_fart_timer_timeout())
	invincibility_timer = Timer.new()
	add_child(invincibility_timer)
	invincibility_timer.connect("timeout", func(): _on_invicibility_timer_timeout())


func _input(event):
	if event.is_action_pressed("stomp") && current_stomp_instance == null && fart_useable :
		current_stomp_instance = null
		fart_useable = false
		fart_timer.start(fart_cooldown)
		invincible = true
		is_stomping = true
		animated_sprite.play("stomp_complete")

func activate_fart_hitbox():
	current_stomp_instance = null
	current_stomp_instance = stomp_scene.instantiate() as Stomp
	await get_tree().process_frame
	current_stomp_instance.stomp_finished.connect(finish_stomp)
	add_child(current_stomp_instance)
	current_stomp_instance.activate(self)
	$FireFartSound.play()
	
func finish_stomp():
	is_stomping = false
	activated_stomp_hitbox = false
	remove_child(current_stomp_instance)
	current_stomp_instance = null
	invincibility_timer.start(fart_invincibility)

func _on_fart_timer_timeout():
	fart_timer.stop()
	fart_useable = true

func _on_invicibility_timer_timeout():
	invincibility_timer.stop()
	invincible = false


func _process(delta):
	if animated_sprite.animation == "stomp_complete" and animated_sprite.frame == 7 && !activated_stomp_hitbox:
		activate_fart_hitbox()
		activated_stomp_hitbox = true
	
	survived_timer += delta
	
	if !health_timer.is_stopped():
		var time_frames_survived = int(survived_timer / time_frame_length)
		if time_frames_survived >= 1:
			survived_timer = 0
			ui.update_time_score(time_frames_survived)
		#ui.update_countdown(health_timer.time_left)
		ui.update_progress_bar(health_timer.time_left)
		
	if is_in_puddle:
		if not $ExtinguishSound.playing:
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


func damage_feedback():
	$PlayerDamage.play()
	damage_animation.play("damage")

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
	
	# no damage during and after stomp for a certain time (fart_invinciblity)
	if !invincible:
		if parent is Enemy || parent is JumpingEnemy || parent is FlyingEnemy:
			# Deal contact damage
			#print("decreasing timer by " + str(parent.contact_damage))
			subtract_health_time(parent.contact_damage)
			damage_feedback()
			received_damage.emit(parent.contact_damage)
		if parent is EnvironmentDamage:
			is_in_puddle = true
			damage_feedback()
		if parent is EnemyBullet:
			# Deal bullet damage
			var enemy_bullet = parent as EnemyBullet
			#print("decreasing timer by " + str(enemy_bullet.damage))
			subtract_health_time(enemy_bullet.damage)
			received_damage.emit(enemy_bullet.damage)
			damage_feedback()

func _on_area_exited(area: Area2D):
	var parent = area.get_parent()
	if parent is EnvironmentDamage:
		is_in_puddle = false
		$PlayerDamage.play()
