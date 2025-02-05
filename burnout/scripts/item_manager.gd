extends Node

@onready var items: Node = $Items
@export var regular_flame_scene: PackedScene
@export var blue_flame_scene: PackedScene
@export var spawn_frequency: float = 5
@export var blue_flame_probability: float = 0.1
@export var item_spawn_points: Array[Node2D]
@export var max_items = 1
var spawn_timer: float = 0;
var current_items: Array[Node2D] = []

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= spawn_frequency:
		spawn_item()
		spawn_timer = 0

func spawn_item():
	# removes queue_freed items
	var removed_item = true
	while removed_item:
		removed_item = false
		for i in range(0, current_items.size()):
			if !is_instance_valid(current_items[i]):
				current_items.remove_at(i)
				removed_item = true
				break
	
	if current_items.size() >= max_items:
		return
	
	var random_index = randi_range(0, item_spawn_points.size() - 1)
	var random_spawn_point = item_spawn_points[random_index] as Node2D
	
	var random_number = RandomNumberGenerator.new().randf_range(0, 1)
	var item_scene = regular_flame_scene
	if random_number <= blue_flame_probability:
		item_scene = blue_flame_scene
		
	var item_instance = item_scene.instantiate() as TimeItem
	items.add_child(item_instance)
	item_instance.global_position = random_spawn_point.global_position
	current_items.append(item_instance)
	print("spawning item")
