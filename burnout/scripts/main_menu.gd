extends Node

@export_file("*.tscn") var intro_scene_path: String

@onready var main_menu_elements: MarginContainer = $GroundBackground/MainMenuElements
@onready var options_menu: MarginContainer = $GroundBackground/OptionsMenu


func _on_start_button_clicked() -> void:
	ClickSound.play()
	await ClickSound.finished
	get_tree().call_deferred("change_scene_to_file", intro_scene_path)


func _on_quit_button_clicked() -> void:
	ClickSound.play()
	await ClickSound.finished
	get_tree().quit()


func _on_options_button_pressed() -> void:
	ClickSound.play()
	main_menu_elements.visible = false
	options_menu.visible = true


func _on_exit_button_pressed() -> void:
	ClickSound.play()
	main_menu_elements.visible = true
	options_menu.visible = false
