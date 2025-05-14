extends Node2D

# Referências automáticas para os nós necessários
@onready var generator = $OperationGenerator
@onready var question_label = $QuestionLabel
@onready var input_field = $InputField_for_answer
@onready var submit_button = $SubmitButton
@onready var fail_zone = $FailZone
@onready var spawn_timer = $SpawnTimer
@onready var correct_song = $right_answer
@onready var animation = $player_sprite

# Cena das perguntas que caem (pré-carregada para performance)
var falling_question_scene = preload("res://scenes/gameplay/FallingQuestion.tscn")

# Lista das perguntas atualmente ativas na tela
var active_questions: Array = []

# Executado ao iniciar a cena
func _ready():
	animation.play("Run_Up")  # Animação de início
	MusicController.play_music_for("gameplay")  # Música do modo gameplay

	randomize()  # Garante aleatoriedade nas perguntas
	fail_zone.body_entered.connect(_on_fail_zone_body_entered)  # Conecta evento de colisão com a zona de falha
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)  # Conecta o timer à função de gerar novas perguntas

	generate_new_question()  # Gera a primeira pergunta
	spawn_timer.start()  # Inicia o timer para continuar gerando perguntas

# Define o modo atual do jogo (adição, subtração etc.)
var selected_mode: String = "add"  # Modo padrão

func set_mode(mode: String):
	selected_mode = mode

# Gera uma nova operação matemática na tela
func generate_new_question():
	var operation = generator.generate_operation(selected_mode)  # Gera pergunta com base no modo
	var question = falling_question_scene.instantiate()  # Instancia a cena da pergunta
	question.question = operation["question"]
	question.answer = operation["answer"]
	question.position = Vector2(randi() % 400 + 100, 0)  # Posição X aleatória, Y no topo

	question.connect("question_failed", _on_question_failed.bind(question))  # Conecta o sinal de falha da questão
	add_child(question)  # Adiciona a pergunta à cena
	active_questions.append(question)  # Armazena na lista de perguntas ativas
	animation.play("Run_Up")  # Animação de foco
	update_ui("Responda a operação correta!")  # Atualiza a interface

# Verifica se a resposta do jogador é válida
func check_answer():
	var text = input_field.text.strip_edges()  # Remove espaços

	if text == "":
		return  # Se estiver vazio, não faz nada

	if not text.is_valid_int():
		update_ui("Digite um número válido.")
		return

	var player_answer = int(text)

	# Percorre as perguntas ativas para verificar se a resposta está correta
	for q in active_questions:
		if is_instance_valid(q) and not q.answered and player_answer == q.answer:
			q.answered = true
			q.queue_free()  # Remove da tela
			active_questions.erase(q)  # Remove da lista
			input_field.text = ""  # Limpa o campo de resposta

			await get_tree().process_frame
			input_field.grab_focus()  # Reaplica foco no campo

			correct_song.play()  # Toca som de acerto
			animation.play("Run_Down")  # Animação de sucesso
			update_ui("Correto!")
			return  # Sai da função

	# Se nenhuma pergunta for respondida corretamente
	animation.play("Fall")
	update_ui("Nenhuma operação corresponde.")
	input_field.text = ""  # Limpa o campo

	await get_tree().process_frame
	input_field.grab_focus()

# Atualiza a mensagem do rótulo e mantém o foco no campo de entrada
func update_ui(message: String):
	question_label.text = message
	input_field.grab_focus()

# -------------------- SINAIS ---------------------

# Quando o botão de enviar for pressionado
func _on_submit_button_pressed():
	check_answer()
	input_field.grab_focus()

# Quando o jogador pressionar "Enter" no campo de entrada
func _on_input_field_for_answer_text_submitted(new_text):
	check_answer()
	input_field.grab_focus()

# Quando uma pergunta não for respondida a tempo
func _on_question_failed(question):
	active_questions.erase(question)
	update_ui("Uma conta caiu sem resposta!")

# Quando algo colidir com a zona de falha
func _on_fail_zone_body_entered(body):
	animation.play("Fall")
	print("Algo colidiu com a fail zone: ", body)

	# Se for um corpo válido com o método de sinal, emite falha
	if body is CharacterBody2D and body.has_method("emit_signal"):
		body.emit_signal("question_failed")
		body.queue_free()

# Quando o tempo do timer acabar, gera nova pergunta
func _on_spawn_timer_timeout():
	generate_new_question()

# Botão para retornar ao menu principal
func _on_return_to_menu_pressed() -> void:
	$buttonclick.play()
	await $buttonclick.finished
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
