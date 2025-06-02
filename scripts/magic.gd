extends CharacterBody2D

@export var speed = 1000
var direction = Vector2.RIGHT
var damage = 10

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
	if abs(global_position.x) > 1000:
		queue_free()
		
