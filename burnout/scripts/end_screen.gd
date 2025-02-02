class_name EndScreen
extends Control

const FILE_PATH: String = "user://saves/"
const FILE_NAME: String = "burnout_highscores.tres"

var highscore_list: ScoreList = ScoreList.new() # neue ScoreList wird Erzeugt

@onready var run_time: String = UI.run_time_output()
@onready var score: int = UI.current_score
@export var run_time_display: Label
@export var name_input: LineEdit

static var last_name: String = ""
static var last_score: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusic.stop()
	$GameOverSound.play()
	run_time_display.text = "Your score: " + str(score)
	
	if !DirAccess.dir_exists_absolute(FILE_PATH):
		DirAccess.make_dir_absolute(FILE_PATH)
	
	load_highscores()


func _on_name_input_text_submitted(_new_text: String) -> void:
	save_run_time()
	ClickSound.play()
	await ClickSound.finished
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game/HighscoreBoard.tscn")

func _on_save_button_pressed():
	save_run_time()
	ClickSound.play()
	await ClickSound.finished
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game/HighscoreBoard.tscn")

func save_run_time():
	# Bricht die Funktion ab, falls kein Name eingegeben wurde/ der String leer ist.
	if name_input.text == "":
		return
	
	# Fügt der Highscoreliste einen neuen Eintrag hinzu.
	highscore_list.add_score_entry(name_input.text, score)
	last_name = name_input.text
	last_score = score
	
	# Speichert die Änderungen
	save_highscores()
	
	#leert den Input Text
	name_input.text = ""


func load_highscores():
	if ResourceLoader.exists(FILE_PATH + FILE_NAME):
		highscore_list = ResourceLoader.load(FILE_PATH + FILE_NAME) as ScoreList


# Speichert die Highscoreliste ab.
func save_highscores():
	for i:int in range (0, highscore_list.names.size()):
		print(highscore_list.names[i] + ": " + str(highscore_list.scores[i]) + "\n")
	ResourceSaver.save(highscore_list, FILE_PATH + FILE_NAME)
