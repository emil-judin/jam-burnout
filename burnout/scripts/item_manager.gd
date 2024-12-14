extends Node

@onready var items: Node = $Items
@export var item_scene: PackedScene
@export var spawn_frequency: float = 5
@export var item_spawn_points: Array[Node2D]
var spawn_timer: float = 0;

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= spawn_frequency:
		spawn_item()
		spawn_timer = 0

func spawn_item():
	var random_index = randi_range(0, item_spawn_points.size() - 1)
	var random_spawn_point = item_spawn_points[random_index] as Node2D
	
	var item_instance = item_scene.instantiate() as TimeItem
	items.add_child(item_instance)
	item_instance.global_position = random_spawn_point.global_position
	print("spawning items")
