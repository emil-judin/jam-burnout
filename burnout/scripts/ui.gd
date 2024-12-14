class_name UI
extends CanvasLayer



@export var wait_time: float = 290.0  # seconds
@export var max_time: float = 300.0

var timer = null

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


func transition_to_end() -> void:
	pass
	# save run time to file
	# change scene to endscreen
