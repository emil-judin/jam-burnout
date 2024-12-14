extends CanvasLayer



@export var wait_time: float = 5.0  # seconds
var timer = null
@onready var countdown_label: RichTextLabel = $Control/VBoxContainer/Top/MarginContainer2/Countdown

func _ready():
	timer = Timer.new()
	timer.set_wait_time(wait_time)
	add_child(timer)
	timer.connect("timeout", func(): _on_timer_timeout()) 
	timer.start()

func _process(delta):
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
		
		if msec <= 9:
			msec_output = "0" + msec_output
		
		countdown_label.text = min_output + ":" +  sec_output + ":" + msec_output
		
		if Input.is_action_just_pressed("+"):
			add_time(10)
		if Input.is_action_just_pressed("-"):
			subtract_time(10)

func _on_timer_timeout():
	print("Countdown complete!")
	timer.stop()


func add_time(seconds: float) -> void:
	timer.start(timer.time_left + seconds)


func subtract_time(seconds: float) -> void:
	if timer.time_left - seconds > 0:
		"timer"
		timer.start(timer.time_left - seconds)
	else:
		print("timer 0")
		timer.stop()
