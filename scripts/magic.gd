extends CharacterBody2D

@export var speed = 1000
var direction = Vector2.RIGHT
var damage = 10

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	
	if abs(global_position.x) > 10000:
		queue_free()
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		
	queue_free()
