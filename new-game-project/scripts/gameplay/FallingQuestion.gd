extends CharacterBody2D

var question = ""
var answer = 0
var speed = 50.0
var answered = false

signal question_failed

@onready var label = $pergunta
@onready var collision_shape = $CollisionShape2D  # A colisão da pergunta

func _ready():
	label.text = question

func _physics_process(delta):
	if not answered:
		velocity = Vector2(0, speed)
		move_and_slide()

func _on_question_failed():
	# Emitir o sinal quando falhar
	emit_signal("question_failed")
	queue_free()  # Liberar a pergunta da cena
