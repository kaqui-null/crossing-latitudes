extends CharacterBody2D

@export var speed: float = 100.0
@export var distancia: float = 200.0

var direcao: int = 1
var pos_inicial: Vector2

func _ready():
	pos_inicial = position
	$AnimatedSprite2D.play("teste")

func _physics_process(delta):
	velocity.x = direcao * speed
	move_and_slide()

	# Inverter a direção se passou do limite
	if abs(position.x - pos_inicial.x) >= distancia:
		direcao *= -1
		$AnimatedSprite2D.flip_h = direcao < 0
