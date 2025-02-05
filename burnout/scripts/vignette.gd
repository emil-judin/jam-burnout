extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer 

func play_vignette_damage_animation(damage: float):
	animation_player.play("activate_vignette")
