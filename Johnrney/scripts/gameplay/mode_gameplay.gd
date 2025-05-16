extends Node2D

# Referências automáticas para os nós na cena
@onready var generator = $OperationGenerator
@onready var question_label = $QuestionLabel
@onready var input_field = $InputField_for_answer
@onready var submit_button = $SubmitButton
@onready var fail_zone = $FailZone
@onready var spawn_timer = $SpawnTimer
@onready var correct_song = $PlayerController/player_sprite/right_answer
@onready var wrong_or_miss = $PlayerController/player_sprite/wrong
@onready var animation = $PlayerController/player_sprite

# Referência ao novo nó PlayerController, que lida com falhas e game over
@onready var player_controller = $PlayerController

# Carrega a cena da pergunta que vai cair do topo
var falling_question_scene = preload("res://scenes/gameplay/FallingQuestion.tscn")

# Lista que guarda as perguntas ativas na tela
var active_questions: Array = []

# Define o modo atual do jogo (adição, subtração, etc)
var selected_mode: String = "add"

func _ready():
	# Toca animação de início e música
	animation.play("Run_Up")
	MusicController.play_music_for("gameplay")
	randomize()

	# Conecta eventos de colisão e game over
	fail_zone.body_entered.connect(_on_fail_zone_body_entered)
	player_controller.game_over.connect(_on_game_over)

	# Gera a primeira pergunta e inicia o timer de geração contínua
	generate_new_question()
	spawn_timer.start()

func set_mode(mode: String):
	# Altera o tipo de operação (ex: "add", "sub")
	selected_mode = mode

func generate_new_question():
	# Gera uma operação matemática com base no modo
	var operation = generator.generate_operation(selected_mode)
	var question = falling_question_scene.instantiate()
	question.question = operation["question"]
	question.answer = operation["answer"]
	question.position = Vector2(randi() % 400 + 100, 0)

	# Conecta o sinal "question_failed" da pergunta à função local
	question.connect("question_failed", _on_question_failed.bind(question))

	# Adiciona a pergunta à cena e à lista de perguntas ativas
	add_child(question)
	active_questions.append(question)

	# Atualiza animação e instrução para o jogador
	animation.play("Run_Up")
	update_ui("Responda a operação correta!")

func check_answer():
	# Lê e limpa a entrada do jogador
	var text = input_field.text.strip_edges()

	if text == "":
		return

	# Verifica se a entrada é um número válido
	if not text.is_valid_int():
		update_ui("Digite um número válido.")
		return

	var player_answer = int(text)

	# Procura nas perguntas ativas se alguma tem a resposta correta
	for q in active_questions:
		if is_instance_valid(q) and not q.answered and player_answer == q.answer:
			# Marca como respondida, remove da tela e da lista
			q.answered = true
			q.queue_free()
			active_questions.erase(q)
			input_field.text = ""

			await get_tree().process_frame
			input_field.grab_focus()

			# Feedback de resposta correta
			correct_song.play()
			animation.play("Run_Down")
			update_ui("Correto!")
			return

	# Se nenhuma pergunta foi respondida corretamente:
	animation.play("Fall")
	wrong_or_miss.play()
	update_ui("Nenhuma operação corresponde.")
	input_field.text = ""

	await get_tree().process_frame
	input_field.grab_focus()

	# Conta como erro (falha do jogador)
	player_controller.register_failure()

func update_ui(message: String):
	# Atualiza o texto da tela e mantém o foco no campo
	question_label.text = message
	input_field.grab_focus()

# Quando botão "Enviar" for pressionado
func _on_submit_button_pressed():
	check_answer()
	input_field.grab_focus()

# Quando jogador pressionar "Enter"
func _on_input_field_for_answer_text_submitted(new_text):
	check_answer()
	input_field.grab_focus()

# Quando uma pergunta cair e emitir o sinal de falha
func _on_question_failed(question):
	active_questions.erase(question)
	update_ui("Uma conta caiu sem resposta!")
	player_controller.register_failure()

# Quando uma pergunta colidir com a zona de falha
func _on_fail_zone_body_entered(body):
	animation.play("Fall")
	wrong_or_miss.play()
	print("Algo colidiu com a fail zone: ", body)

	if body is CharacterBody2D and body.has_method("emit_signal"):
		body.emit_signal("question_failed")
		body.queue_free()

# Gera uma nova pergunta quando o tempo do Timer acabar
func _on_spawn_timer_timeout():
	generate_new_question()

# Quando o botão de "voltar ao menu principal" for pressionado
func _on_return_to_menu_pressed() -> void:
	$buttonclick.play()
	await $buttonclick.finished
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

# Quando o PlayerController emitir sinal de game over
func _on_game_over():
	update_ui("Game Over!")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menu/Selection_mode_menu.tscn")
