extends Node2D  # Cena principal do gameplay

# ============================== #
# ==== REFERÊNCIAS AUTOMÁTICAS ====
# ============================== #

@onready var generator = $OperationGenerator
@onready var question_label = $QuestionLabel
@onready var input_field = $InputField_for_answer
@onready var submit_button = $SubmitButton
@onready var fail_zone = $FailZone
@onready var spawn_timer = $SpawnTimer
@onready var correct_song = $PlayerController/player_sprite/right_answer
@onready var wrong_or_miss = $PlayerController/player_sprite/wrong
@onready var animation = $PlayerController/player_sprite
@onready var player_controller = $PlayerController
@onready var pause_menu = $PlayerController/healthbar/PauseMenu
@onready var gameOver = $PlayerController/player_sprite/GameOver

# ============================== #
# ========== VARIÁVEIS ========= #
# ============================== #

var paused: bool = false  # Estado de pausa do jogo

# Cena da pergunta que vai "cair" do topo da tela
var falling_question_scene = preload("res://scenes/gameplay/FallingQuestion.tscn")

# Lista que armazena as perguntas ativas (ainda na tela e aguardando resposta)
var active_questions: Array = []

# Modo atual da operação matemática (exemplo: "add", "sub")
var selected_mode: String = "add"


# ============================== #
# ====== FUNÇÕES PRINCIPAIS ===== #
# ============================== #

func _ready() -> void:
	# Inicializa animação de corrida para cima
	animation.play("Run_Up")

	# Começa a tocar música do gameplay
	MusicController.play_music_for("gameplay")

	# Garante aleatoriedade para geração das perguntas
	randomize()

	# Configura o menu de pausa com esta cena para controle
	pause_menu.set_gameplay(self)

	# Conecta o sinal de colisão na zona de falha para função local
	fail_zone.body_entered.connect(_on_fail_zone_body_entered)

	# Conecta sinal de game over vindo do player_controller
	player_controller.game_over.connect(_on_game_over)

	# **Aqui você pode chamar sua função que aplica as configurações**
	#apply_settings()

	# Gera a primeira pergunta e inicia timer de spawn das próximas
	generate_new_question()
	spawn_timer.start()


func _process(delta: float) -> void:
	# Detecta se tecla de pause foi pressionada
	if Input.is_action_just_pressed("pause"):
		pauseMenu()


#func apply_settings() -> void:
	# Exemplo: carregar volume da música salvo nas configurações
#	MusicController.set_volume(GlobalSettings.music_volume)

	# Ajustar a dificuldade, que pode influenciar tempo do spawn, número de falhas, etc.
#	selected_mode = GlobalSettings.difficulty_mode

	# Exemplo: ajustar velocidade do spawn conforme dificuldade
#	if selected_mode == "hard":
#		spawn_timer.wait_time = 1.0
#	else:
#		spawn_timer.wait_time = 2.0

	# Atualiza UI para mostrar modo selecionado
#	update_ui("Modo: %s" % selected_mode)


func pauseMenu() -> void:
	# Alterna o estado de pausa
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1  # Retoma o tempo do jogo
	else:
		pause_menu.show()
		Engine.time_scale = 0  # Pausa o tempo do jogo (congela)

	paused = !paused


func set_mode(mode: String) -> void:
	# Atualiza o modo de operação matemática
	selected_mode = mode


func generate_new_question() -> void:
	# Gera operação usando o gerador com base no modo selecionado
	var operation = generator.generate_operation(selected_mode)

	# Instancia a pergunta que cairá na tela
	var question = falling_question_scene.instantiate()

	# Inicializa a pergunta com texto e resposta correta
	question.initialize(operation["question"], operation["answer"])

	# Define posição inicial aleatória no eixo X (100 a 500), topo (y=0)
	question.position = Vector2(randi() % 400 + 100, 0)

	# Conecta sinal para detectar quando a pergunta "falha" (cai sem resposta)
	question.connect("question_failed", _on_question_failed.bind(question))

	# Adiciona pergunta à cena e lista de ativas
	add_child(question)
	active_questions.append(question)

	# Animação de corrida
	animation.play("Run_Up")

	# Atualiza texto da UI para instruir o jogador
	update_ui("Responda a operação correta!")


func check_answer() -> void:
	var text = input_field.text.strip_edges()

	if text == "":
		return

	if not text.is_valid_int():
		update_ui("Digite um número válido.")
		return

	var player_answer = int(text)

	for q in active_questions:
		if is_instance_valid(q) and not q.answered and player_answer == q.answer:
			q.answered = true
			q.collision_shape.disabled = true
			q.queue_free()
			active_questions.erase(q)
			input_field.text = ""
			await get_tree().process_frame
			input_field.grab_focus()

			correct_song.play()
			animation.play("Run_Down")

			update_ui("Correto!")

			# <-- Aqui, registra acerto no SaveManager
			SaveManager.add_score(selected_mode)

	return

	# Se não acertou nenhuma operação:
	animation.play("Fall")
	wrong_or_miss.play()
	update_ui("Nenhuma operação corresponde.")
	input_field.text = ""
	await get_tree().process_frame
	input_field.grab_focus()

	# Registra erro no SaveManager
	SaveManager.add_error()

	animation.play("Run_Up")




func update_ui(message: String) -> void:
	# Atualiza texto na UI e foca campo de resposta
	question_label.text = message
	input_field.grab_focus()


# ============================== #
# ====== SIGNALS / HANDLERS ===== #
# ============================== #

func _on_submit_button_pressed() -> void:
	check_answer()
	input_field.grab_focus()


func _on_input_field_for_answer_text_submitted(_new_text: String) -> void:
	check_answer()
	input_field.grab_focus()


func _on_question_failed(question) -> void:
	active_questions.erase(question)
	update_ui("Uma conta caiu sem resposta!")

	# Registra falha no player_controller
	player_controller.register_failure()

	# Registra erro no SaveManager
	SaveManager.add_error()


func _on_fail_zone_body_entered(body) -> void:
	animation.play("Fall")
	wrong_or_miss.play()

	# Se o corpo que colidiu for personagem com método fail, chama ele
	if body is CharacterBody2D and body.has_method("fail"):
		body.fail()


func _on_spawn_timer_timeout() -> void:
	# Gera nova pergunta quando timer expira
	generate_new_question()


func _on_return_to_menu_pressed() -> void:
	# Retoma tempo e troca para cena de menu principal
	Engine.time_scale = 1
	$buttonclick.play()
	await $buttonclick.finished
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func restart_game() -> void:
	# Garante que tempo está normal
	Engine.time_scale = 1

	# Carrega nova instância do gameplay mantendo o modo selecionado
	var scene = preload("res://scenes/gameplay/mode_gameplay.tscn").instantiate()
	scene.set_mode(selected_mode)

	# Adiciona à raiz da árvore de cena, remove a atual e atualiza referência
	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene


func _on_game_over() -> void:
	# Toca animação de game over, atualiza UI e troca de cena após delay
	gameOver.play()
	Engine.time_scale = 1
	update_ui("Game Over!")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menu/Selection_mode_menu.tscn")


func _on_reiniciar_pressed() -> void:
	Engine.time_scale = 1
	get_tree().paused = false
	restart_game()


func _on_pause_pressed() -> void:
	pauseMenu()
