class_name UI
extends CanvasLayer

static var game_start_time
static var current_score: int

@export var countdown_label: RichTextLabel
@export var score_label: RichTextLabel
@export var progress_bar: ProgressBar
#@export var flame_texture: Sprite2D
@export var flame_texture: TextureRect
@export var fart_animated_sprite: AnimatedSprite2D

func _ready():
	activate_fart()

static func reset_game_start_time():
	UI.game_start_time = Time.get_ticks_msec()
	current_score = 0

func initialize_health_ui(start_health_time: float, max_health_time: float):
	progress_bar.max_value = max_health_time
	#update_countdown(start_health_time)
	update_progress_bar(start_health_time)
	update_time_score(0)

func deactivate_fart():
	fart_animated_sprite.play("inactive")

func activate_fart():
	fart_animated_sprite.play("activate")

#func update_countdown(time_left: float) -> void:
	#var current_time = time_left
	#var min = int(current_time) / 60
	#var min_output = str(min)
	#var sec = int(current_time) - min * 60
	#var sec_output = str(sec)
	#var msec = int((snappedf(current_time, 0.01) - sec - min * 60) *100)
	#var msec_output = str(msec)
	#
	#if min <= 9:
		#min_output = "0" + min_output
	#
	#if sec <= 9:
		#sec_output = "0" + sec_output
	#
	#if msec == 100:
		#msec_output = "00"
	#if msec <= 9:
		#msec_output = "0" + msec_output
	#
	#countdown_label.text = min_output + ":" +  sec_output + ":" + msec_output
	
func update_time_score(survived_time_frames: int):
	const time_frame_score = 1000
	# get 1000 points per 10 second
	current_score += survived_time_frames * time_frame_score
	# get 100 points for every killed enemy

func _process(delta):
	score_label.text = str(current_score)

func update_progress_bar(time_left: float) -> void:
	progress_bar.value = time_left
	flame_texture.global_position.y = progress_bar.global_position.y - flame_texture.size.y + progress_bar.size.y - progress_bar.size.y * (progress_bar.value / progress_bar.max_value)

static func run_time_output() -> String:
	var run_time = Time.get_ticks_msec() - game_start_time
	
	var min = run_time/1000/60
	var min_output = str(min)
	var sec = run_time/1000%60
	var sec_output = str(sec)
	var msec = run_time%1000/10
	var msec_output = str(msec)

	# Sorgt dafür das die Zahlen richtig dargestellt werden wenn sie unter 9 sind.
	if min <= 9:
		min_output = "0" + str(min)
		
	if sec <= 9:
		sec_output = "0" + str(sec)
		
	if msec <= 9:
		msec_output = "0" + str(msec)
	
	# Gibt die einzelnen Strings als zusammengesetzten String zurück.
	return min_output+ ":" + sec_output+ ":" + msec_output
