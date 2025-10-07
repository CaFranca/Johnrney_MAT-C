extends CharacterBody2D

var question = ""
var answer = 0

var answered = false

static var DEFAULT_SPEED = 50
var MAX_SPEED = 300.0
var SPEED_INCREMENT = 2

func set_difficulty(difficulty:String):
	match (difficulty):
		"normal":
			print("dificuldade:", difficulty)
		"hard":
			print("dificuldade:", difficulty)
			DEFAULT_SPEED = 100
			MAX_SPEED = 600.0
			SPEED_INCREMENT = 5

signal question_failed

@onready var label = $pergunta
@onready var collision_shape = $Answerhitbox

# Velocidade compartilhada para próximas perguntas
static var speed = DEFAULT_SPEED

func _ready():
	if question != "":
		label.text = question

func initialize(new_question: String, new_answer: int):
	question = new_question
	answer = new_answer
	if label:
		label.text = question

	# Define a velocidade da pergunta
	# Aumenta para a próxima pergunta
	speed = min(speed + SPEED_INCREMENT, MAX_SPEED)
	print(speed)

func _physics_process(_delta):
	if not answered:
		velocity = Vector2(0, speed)
		move_and_slide()

func fail():
	if not answered:
		answered = true
		emit_signal("question_failed")
		queue_free()

static func reset_speed():
	speed = DEFAULT_SPEED



# Código opcional para debug (ativar se quiser acompanhar quando a pergunta for removida)
#func _exit_tree():
#	print("FallingQuestion removida:", self)
