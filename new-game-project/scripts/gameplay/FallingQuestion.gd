extends CharacterBody2D  # Este script representa uma pergunta que se move na tela, como no estilo TuxMath

# Variáveis principais da pergunta
var question = ""      # Texto da operação matemática (ex: "2 + 2")
var answer = 0         # Resposta correta da pergunta
var speed = 70.0       # Velocidade de queda da pergunta
var answered = false   # Indica se a pergunta já foi respondida

# Sinal que será emitido quando a pergunta não for respondida a tempo
signal question_failed

# Referência ao Label que exibe a pergunta na tela
@onready var label = $pergunta

# Referência à forma de colisão da pergunta
@onready var collision_shape = $CollisionShape2D

func _ready():
	# Define o texto do Label como a pergunta
	label.text = question

func _physics_process(delta):
	# Faz a pergunta "cair" se ainda não tiver sido respondida
	if not answered:
		velocity = Vector2(0, speed)  # Move apenas no eixo Y
		move_and_slide()              # Aplica movimento com colisão

func _on_question_failed():
	# Quando a pergunta não for respondida (por exemplo, colidir com a base):
	emit_signal("question_failed")  # Emite o sinal para que o jogo saiba que o jogador errou
	queue_free()                    # Remove a pergunta da cena (limpa da memória)
