class_name UI
extends CanvasLayer

static var game_start_time = Time.get_ticks_msec()

@export var countdown_label: RichTextLabel
@export var progress_bar: TextureProgressBar

func initialize_health_ui(start_health_time: float, max_health_time: float):
	progress_bar.max_value = max_health_time
	update_countdown(start_health_time)
	update_progress_bar(start_health_time)

func update_countdown(time_left: float) -> void:
	var current_time = time_left
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

func update_progress_bar(time_left: float) -> void:
	progress_bar.value = time_left

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
