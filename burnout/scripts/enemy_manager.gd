extends Node

@onready var enemies: Node = $Enemies
@export var player: Player
@export var enemy_scene: PackedScene
@export var spawn_frequency: float = 1
@export var enemy_spawn_points: Array[Node2D]
var spawn_timer: float = 0;

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= spawn_frequency:
		spawn_enemy()
		spawn_timer = 0

func spawn_enemy():
	var random_index = randi_range(0, enemy_spawn_points.size() - 1)
	var random_spawn_point = enemy_spawn_points[random_index] as Node2D
	
	var enemy_instance = enemy_scene.instantiate() as Enemy
	enemies.add_child(enemy_instance)
	enemy_instance.target = player
	enemy_instance.global_position = random_spawn_point.global_position
	enemy_instance.start_chase()
