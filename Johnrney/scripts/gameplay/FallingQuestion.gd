extends CharacterBody2D

var question = ""
var answer = 0

var answered = false

static var DEFAULT_SPEED
static var MAX_SPEED = 300.0
static var SPEED_INCREMENT = 2
var parar_questaoteste: bool = false
var y_stop_position = 350
signal question_failed
@onready var label = $pergunta
@onready var collision_shape = $Answerhitbox

# Velocidade compartilhada para próximas perguntas
static var speed = DEFAULT_SPEED

func set_difficulty(difficulty:String):
	match (difficulty):
		"normal":
			DEFAULT_SPEED = 50
			MAX_SPEED = 300.0
			SPEED_INCREMENT = 5
		"hard":
			DEFAULT_SPEED = 100
			MAX_SPEED = 600.0
			SPEED_INCREMENT = 10
		_:
			print("Dificuldade não encontrada:",difficulty)
	print("Dificuldade encontrada:",difficulty)
	

func _ready():
	if question != "":
		label.text = question

func initialize(new_question: String, new_answer: int, stop: bool = false):
	question = new_question
	answer = new_answer
	if label:
		label.text = question

	self.parar_questaoteste = stop

	speed = min(speed + SPEED_INCREMENT, MAX_SPEED)
	print("Velocidade: ", speed)

func _physics_process(_delta):
	# Se já foi respondida, para tudo.
	if answered:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if parar_questaoteste:
		if position.y >= y_stop_position:
			velocity = Vector2.ZERO
			position.y = y_stop_position 
		else:
			velocity = Vector2(0, speed)
	else:
		velocity = Vector2(0, speed)

	# move o corpo apenas 1 vez, depois de toda a validação
	move_and_slide()

func fail():
	if not answered:
		answered = true
		emit_signal("question_failed")
		queue_free()

static func reset_speed():
	speed = DEFAULT_SPEED
