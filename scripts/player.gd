extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = Vector2.RIGHT
@export var magic_scene = PackedScene

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func shoot():
	if magic_scene:
		var instance = magic_scene.instanciate()
		get_tree().current_scene.add_child(instance)
		
		if Input.is_action_pressed("aim_mode"):
			var input_dir = Input.get_vector("left", "right", "up", "down")
			dir = get_aim_direction(input_dir)


func get_aim_direction(input_dir: Vector2) -> Vector2:
	if input_dir.length() == 0:
		return facing_direction  # ou qualquer padrão
	
	var angle = rad_to_deg(input_dir.angle())
	
	if angle < -157.5 or angle > 157.5:
		return Vector2.LEFT
	elif angle < -112.5:
		return (Vector2.LEFT + Vector2.UP).normalized()
	elif angle < -67.5:
		return Vector2.UP
	elif angle < -22.5:
		return (Vector2.RIGHT + Vector2.UP).normalized()
	elif angle < 22.5:
		return Vector2.RIGHT

	return facing_direction
