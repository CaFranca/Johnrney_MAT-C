extends CharacterBody2D  # Representa uma pergunta que se move na tela

# Variáveis principais da pergunta
var question = ""      # Texto da operação matemática (ex: "2 + 2")
var answer = 0         # Resposta correta da pergunta
var speed = 70.0       # Velocidade de queda da pergunta
var answered = false   # Indica se a pergunta já foi respondida (evita múltiplas respostas ou falhas)

# Sinal emitido quando a pergunta não for respondida a tempo
signal question_failed

# Referência ao texto da operação e à hitbox
@onready var label = $pergunta             # Label que exibe a pergunta na tela
@onready var collision_shape = $Answerhitbox  # Hitbox usada para detectar se a pergunta foi perdida

func _ready():
	# Define o texto do label se a pergunta já tiver sido configurada antes da entrada na cena
	if question != "":
		label.text = question

# Inicializa a pergunta com um novo texto e resposta correta
func initialize(new_question: String, new_answer: int):
	question = new_question
	answer = new_answer
	# Atualiza o label na interface
	if label:
		label.text = question

func _physics_process(_delta):
	if not answered:
		# Move a pergunta para baixo enquanto não foi respondida
		velocity = Vector2(0, speed)  # Movimento vertical com velocidade constante
		move_and_slide()  # Aplica o movimento com colisão

# Método central que trata a falha da pergunta (ex.: colidir com a zona de erro)
func fail():
	if not answered:
		answered = true
		emit_signal("question_failed")  # Notifica que a pergunta não foi respondida a tempo
		queue_free()  # Remove a pergunta da cena, liberando memória

# Código opcional para debug (ativar se quiser acompanhar quando a pergunta for removida)
#func _exit_tree():
#	print("FallingQuestion removida:", self)
