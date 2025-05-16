extends CharacterBody2D  # Representa uma pergunta que se move na tela

# Variáveis principais da pergunta
var question = ""      # Texto da operação matemática (ex: "2 + 2")
var answer = 0         # Resposta correta da pergunta
var speed = 60.0       # Velocidade de queda da pergunta
var answered = false   # Indica se a pergunta já foi respondida

# Sinal emitido quando a pergunta não for respondida a tempo
signal question_failed

# Referência ao texto da operação e à hitbox
@onready var label = $pergunta
@onready var collision_shape = $Answerhitbox

func _ready():
	if question != "":
		label.text = question

func initialize(new_question: String, new_answer: int):
	question = new_question
	answer = new_answer
	if label:
		label.text = question

func _physics_process(delta):
	if not answered:
		# Move a pergunta para baixo enquanto não foi respondida
		velocity = Vector2(0, speed)
		move_and_slide()

# Método central que trata a falha da pergunta (colisão com zona de erro)
func fail():
	if not answered:
		answered = true
		emit_signal("question_failed")  # Notifica que a pergunta falhou
		queue_free()  # Remove a pergunta da cena

func _exit_tree():
	print("FallingQuestion removida:", self)
