extends Node

@export_file("*.tscn") var start_scene_path: String

func _on_start_button_clicked():
	get_tree().change_scene_to_file(start_scene_path)
	
func _on_quit_button_clicked():
	get_tree().quit()
