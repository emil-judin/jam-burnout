class_name UI
extends CanvasLayer

@export var wait_time: float = 10.0  # seconds
@export var max_time: float = 300.0

var timer = null
static var game_start_time = Time.get_ticks_msec()

@onready var countdown_label: RichTextLabel = $Control/MainContainer/TopBox/MarginContainer2/Countdown
@onready var progress_bar: ProgressBar = $Control/ProgressBarContainer/MarginContainer/ProgressBar

func _ready():
	progress_bar.max_value = max_time
	timer = Timer.new()
	timer.set_wait_time(wait_time)
	add_child(timer)
	timer.connect("timeout", func(): _on_timer_timeout()) 
	timer.start()

func _process(delta):
	update_countdown()
	update_progress_bar()
	
	if Input.is_action_just_pressed("+"):
		add_time(10)
	if Input.is_action_just_pressed("-"):
		subtract_time(10)

func update_countdown() -> void:
	if timer:
		var current_time = timer.time_left
		var min = int(current_time) / 60
		var min_output = str(min)
		var sec = int(current_time) - min * 60
		var sec_output = str(sec)
		var msec = int((snappedf(current_time, 0.01) - sec - min * 60) *100)
		var msec_output = str(msec)
		
		if min <= 9:
			min_output = "0" + min_output
		
		if sec <= 9:
			sec_output = "0" + sec_output
		
		if msec == 100:
			msec_output = "00"
		if msec <= 9:
			msec_output = "0" + msec_output
		
		countdown_label.text = min_output + ":" +  sec_output + ":" + msec_output

func update_progress_bar() -> void:
	if timer:
		progress_bar.value = timer.time_left 

func _on_timer_timeout() -> void:
	timer.stop()
	transition_to_end()


func add_time(seconds: float) -> void:
	if timer.time_left + seconds <= max_time:
		timer.start(timer.time_left + seconds)
	else:
		timer.start(max_time)


func subtract_time(seconds: float) -> void:
	if timer.time_left - seconds > 0:
		timer.start(timer.time_left - seconds)
	else:
		timer.stop()
		transition_to_end()


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

func transition_to_end() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game/EndScreen.tscn")
