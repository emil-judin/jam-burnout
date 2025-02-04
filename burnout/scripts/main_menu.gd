extends Node

@export_file("*.tscn") var intro_scene_path: String

func _on_start_button_clicked():
	ClickSound.play()
	await ClickSound.finished
	get_tree().change_scene_to_file(intro_scene_path)
	
	
func _on_quit_button_clicked():
	ClickSound.play()
	await ClickSound.finished
	get_tree().quit()
