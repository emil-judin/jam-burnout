extends Control

@export_file("*.tscn") var main_scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await $VideoStreamPlayer.finished
	load_main_scene()

func _input(event):
	if event.is_action_pressed("skip_cutscene"):
		load_main_scene()

func load_main_scene():
	get_tree().change_scene_to_file(main_scene_path)
