extends Node
class_name Stomp

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@export var damage: int = 1
@export var cost: float = 10
var activated = false

func activate(player_character_body: CharacterBody2D):
	static_body_2d.add_collision_exception_with(player_character_body)
	animation_player.play("activate_stomp")
	activated = true

func _process(delta):
	if activated && !animation_player.is_playing():
		queue_free()
