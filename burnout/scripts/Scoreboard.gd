class_name Highscoreboard
extends Node

# Dateipfad und Dateiname
const FILE_PATH: String = "user://saves/"
const FILE_NAME: String = "burnout_highscores.tres"
@export var first_place_label: RichTextLabel
@export var second_place_label: RichTextLabel
@export var third_place_label: RichTextLabel
@export var highscore_display: RichTextLabel
@export var highscore_scroll_container: ScrollContainer
@export_file("*.tscn") var main_menu_path: String
@export_file("*.tscn") var game_scene_path: String

var highscore_list: ScoreList = ScoreList.new() # neue ScoreList wird Erzeugt

func _ready():
	# Ruft die Funktionen zum laden und darstellen/aktualisieren der Highscoreliste auf.
	load_highscores()
	update_highscore_display()


# Lädt eine gespeicherte Highscoreliste falls eine existiert.
func load_highscores():
	if ResourceLoader.exists(FILE_PATH + FILE_NAME):
		highscore_list = ResourceLoader.load(FILE_PATH + FILE_NAME) as ScoreList


# Updatet die Darstellung der Highscoreliste
func update_highscore_display():
	
	# Stellt sicher das das display leer ist.
	highscore_display.text = ""
	
	# Fügt alle Einträge aus der geladenen Liste ein
	var sorted_highscore_list = highscore_list.get_sorted_by_highscore()
	
	var no_winner_text = "-"
	if sorted_highscore_list.scores.size() >= 1:
		first_place_label.text = sorted_highscore_list.names[0] + ": " + str(sorted_highscore_list.scores[0])
	else:
		first_place_label.text = no_winner_text
	if sorted_highscore_list.scores.size() >= 2:
		second_place_label.text = sorted_highscore_list.names[1] + ": " + str(sorted_highscore_list.scores[1])
	else:
		second_place_label.text = no_winner_text
	if sorted_highscore_list.scores.size() >= 3:
		third_place_label.text = sorted_highscore_list.names[2] + ": " + str(sorted_highscore_list.scores[2])
	else:
		third_place_label.text = no_winner_text
	
	var new_score_index = 0
	for i in range(0, sorted_highscore_list.names.size()):
		var highscore_name = sorted_highscore_list.names[i]
		var highscore_score = sorted_highscore_list.scores[i]
		var current_bb_open = ""
		var current_bb_close = ""
		
		if highscore_name == EndScreen.last_name && highscore_score == EndScreen.last_score:
			current_bb_open += "[color=orange]"
			current_bb_close += "[/color]"
			new_score_index = i
		
		highscore_display.text += current_bb_open + str(i + 1) + ". " + sorted_highscore_list.names[i] + ": " + str(sorted_highscore_list.scores[i]) + current_bb_close + "\n"
	
	await get_tree().process_frame 
	highscore_scroll_container.scroll_vertical = new_score_index * 80

func _on_replay_pressed():
	ClickSound.play()
	await ClickSound.finished
	get_tree().call_deferred("change_scene_to_file", game_scene_path)

func _on_quit_pressed():
	ClickSound.play()
	await ClickSound.finished
	get_tree().call_deferred("change_scene_to_file", main_menu_path)
