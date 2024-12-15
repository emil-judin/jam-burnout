extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func do_death_animation():
	animation_player.play("death_animation")
