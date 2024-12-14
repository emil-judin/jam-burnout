extends CharacterBody2D
class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var movement_speed: float = 400
#@export var contact_damage_cooldown: float = 2

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.x > 0:
		animated_sprite.play("side_walk")
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.play("side_walk")
		animated_sprite.flip_h = true
	elif direction.y > 0:
		animated_sprite.play("front_walk")
	elif direction.y < 0:
		animated_sprite.play("back_walk")
	else:
		animated_sprite.play("idle")
	velocity = direction * movement_speed
	move_and_slide()
	
func time_item_collected(time_value):
	print("added " + time_value + " collected")

func _on_area_entered(area: Area2D):
	var parent = area.get_parent()
	if parent is TimeItem:
		var time_item = parent as TimeItem
		print("inceasing timer by " + str(time_item.time_value))
		time_item.collect()
	if parent is Enemy || parent is JumpingEnemy:
		# Deal contact damage
		print("decreasing timer by " + str(parent.contact_damage))
