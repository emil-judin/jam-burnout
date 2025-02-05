extends Node
class_name Stomp

signal stomp_finished()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var knockback_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@export var damage: int = 1
@export var cost: float = 10
var activated = false

func _ready():
	knockback_shape.disabled = true

func activate(player_character_body: CharacterBody2D):
	static_body_2d.add_collision_exception_with(player_character_body)
	animation_player.play("activate_stomp")
	activated = true
	knockback_shape.disabled = false

func _on_animation_player_animation_finished(anim_name):
	if activated && anim_name == "activate_stomp":
		knockback_shape.disabled = true
		stomp_finished.emit()
		queue_free()
