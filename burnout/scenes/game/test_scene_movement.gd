extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UI.reset_game_start_time()
	
	if not BackgroundMusic.playing:
		BackgroundMusic.play()
