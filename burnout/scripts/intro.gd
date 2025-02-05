extends Control

@export_file("*.tscn") var tutorial_scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await $VideoStreamPlayer.finished
	load_tutorial_scene()


func _input(event):
	if event.is_action_pressed("skip_cutscene"):
		load_tutorial_scene()


func load_tutorial_scene():
	get_tree().call_deferred("change_scene_to_file", tutorial_scene_path)
