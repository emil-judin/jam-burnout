extends Control


@export_file("*.tscn") var main_scene_path: String

func _on_start_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", main_scene_path)
