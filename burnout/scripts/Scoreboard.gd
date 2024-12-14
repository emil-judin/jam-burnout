class_name Highscoreboard
extends Node

# Dateipfad und Dateiname
const FILE_PATH: String = "user://saves/"
const FILE_NAME: String = "burnout_highscores.tres"


var highscore_list: ScoreList = ScoreList.new() # neue ScoreList wird Erzeugt


@onready var highscore_display: Label = $HighscoreDisplay


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
	print("test1")
	# Stellt sicher das das display leer ist.
	highscore_display.text = ""
	
	# Fügt alle Einträge aus der geladenen Liste ein
	for i:int in range (0, highscore_list.names.size()):
		highscore_display.text += highscore_list.names[i] + ": " + str(highscore_list.times[i]) + "\n"
		#print(highscore_list.names[i] + ": " + str(highscore_list.times[i]) + "\n")

func _on_quit_pressed():
	get_tree().quit()
