extends Node
class_name HealthManager

signal died()

@export var max_health: int = 3
var current_health: int

func _ready():
	current_health = max_health
	
func receive_damage(damage: int):
	current_health -= damage
	if current_health <= 0:
		die()
		
func die():
	died.emit()
