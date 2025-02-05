extends Camera2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
@export var player: Player  # Assign the node this camera will follow.
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

func _ready():
	randomize()

func _process(delta):
	if player:
		global_position = player.global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func add_trauma(amount: float):
	trauma = min(trauma + amount * 0.3, 0.75)

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)

func do_death_animation():
	animation_player.play("death_animation")
