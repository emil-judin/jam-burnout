extends Control

@export_file("*.tscn") var main_scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await $VideoStreamPlayer.finished
	get_tree().change_scene_to_file(main_scene_path)
