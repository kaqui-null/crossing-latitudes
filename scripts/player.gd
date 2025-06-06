extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var direction = Vector2.RIGHT
@export var magic_scene: PackedScene
@onready var magic_spawner = %magic_spawner
var magic_cooldown = 0.1
var magic_timer = 0.0
var dead = false

func _ready() -> void:
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	
	if dead:
		call_deferred("_load_game_over")
	
	if magic_timer > 0:
		magic_timer -= delta
	move(delta)
	handle_attack()
	
	
func move(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if abs(direction)> 0:
			if direction > 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("default")
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("idle")
		
	move_and_slide()

func handle_attack():
	if Input.is_action_pressed("shoot") and magic_timer <= 0:
		shoot()
		magic_timer = magic_cooldown

func shoot():
	if magic_scene:
		var instance = magic_scene.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_transform = magic_spawner.global_transform
		
		var dir = direction
		if Input.is_action_pressed("aim_mode"):
			var input_dir = Input.get_vector("left", "right", "up", "down")
			dir = get_aim_direction(input_dir)
			
		instance.direction = dir
		


func get_aim_direction(input_dir: Vector2) -> Vector2:
	if input_dir.length() == 0:
		return direction  # ou qualquer padrão
	
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

	return direction

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		die()

func die():
	dead = true
	
func _load_game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
