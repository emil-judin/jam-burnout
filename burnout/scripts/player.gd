extends CharacterBody2D
class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var ui: UI
@export var movement_speed: float = 400
@export var max_health_time: float = 300.0
@export var start_health_time: float = 10.0  # seconds
var health_timer: Timer = null

func _ready():
	health_timer = Timer.new()
	health_timer.set_wait_time(start_health_time)
	add_child(health_timer)
	health_timer.connect("timeout", func(): _on_timer_timeout())
	ui.initialize_health_ui(start_health_time, max_health_time)
	health_timer.start()

func _process(delta):
	if !health_timer.is_stopped():
		ui.update_countdown(health_timer.time_left)
		ui.update_progress_bar(health_timer.time_left)

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
	health_timer.stop()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game/EndScreen.tscn")

func _physics_process(delta):
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
		print("inceasing timer by " + str(time_item.time_value))
		time_item_collected(time_item.time_value)
		time_item.collect()
	if parent is Enemy || parent is JumpingEnemy:
		# Deal contact damage
		print("decreasing timer by " + str(parent.contact_damage))
		subtract_health_time(parent.contact_damage)
	if parent is EnemyBullet:
		# Deal bullet damage
		var enemy_bullet = parent as EnemyBullet
		print("decreasing timer by " + str(enemy_bullet.damage))
		subtract_health_time(enemy_bullet.damage)
