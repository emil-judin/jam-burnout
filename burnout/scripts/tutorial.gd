extends Control


@export_file("*.tscn") var main_scene_path: String
@onready var animated_sprite_2d: AnimatedSprite2D = $Background/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/FireFart/CenterContainer/TextureRect/AnimatedSprite2D


func _ready() -> void:
		BackgroundMusic.play()


func _on_start_button_pressed() -> void:
	ClickSound.play()
	await ClickSound.finished
	get_tree().call_deferred("change_scene_to_file", main_scene_path)


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("stomp") and not animated_sprite_2d.is_playing():
		animated_sprite_2d.play()
