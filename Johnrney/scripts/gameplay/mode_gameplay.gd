extends Node2D  # Cena principal do gameplay

# ============================== #
# ==== REFERÊNCIAS AUTOMÁTICAS ==== #
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
@onready var healthbar = $PlayerController/healthbar
@onready var gameOver = $PlayerController/player_sprite/GameOver
@onready var hint_scene = $PlayerController/healthbar/TipScreen
@onready var score_label = $PlayerController/ScoreLabel
@onready var combo_label = $PlayerController/ComboLabel


# ============================== #
# ========== VARIÁVEIS ========= #
# ============================== #

var paused: bool = false  # Estado de pausa do jogo



# Cena da pergunta que vai "cair" do topo da tela
var falling_question_scene = preload("res://scenes/gameplay/FallingQuestion.tscn")
var reset = preload("res://scripts/gameplay/FallingQuestion.gd")

# Lista que armazena as perguntas ativas (ainda na tela e aguardando resposta)
var active_questions: Array = []

# Modo atual da operação matemática (exemplo: "add", "sub")
var selected_mode: String = "add"
var selected_difficulty: String = "normal"
var current_score: int = 0
var current_errors: int = 0 
var current_combo: int = 0
var tutorial_mode = false


# ============================== #
# ====== FUNÇÕES PRINCIPAIS ===== #
# ============================== #

func _ready() -> void:
	var temp_question = falling_question_scene.instantiate()
	temp_question.set_difficulty(selected_difficulty)
	temp_question.queue_free()
	
	reset.reset_speed()
	animation.play("Run_Up")

	hint_scene.hide_tip()  # Esconde a dica ao iniciar
	hint_scene.set_gameplay(self)
	
	current_score = 0
	current_errors = 0
	update_score_label() 
	
	MusicController.play_music_for("gameplay")
	randomize()
	pause_menu.set_gameplay(self)
	fail_zone.body_entered.connect(_on_fail_zone_body_entered)
	player_controller.game_over.connect(_on_game_over)
	
	generate_new_question()

	spawn_timer.start()


func _process(delta: float) -> void:
	# Detecta se tecla de pause foi pressionada
	if Input.is_action_just_pressed("pause"):
		pauseMenu()


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
	
func set_difficulty(difficulty: String) -> void:
	selected_difficulty = difficulty
	
func set_tutorial_mode(is_tutorial: bool):
	tutorial_mode = is_tutorial
	
	# Se o tutorial estiver começando, limpa qualquer conta que já exista
	if is_tutorial:
		spawn_timer.stop() 
		
		for q in active_questions:
			if is_instance_valid(q):
				q.queue_free()
		active_questions.clear()
		
func spawn_tutorial_equation(question_text: String, answer_int: int, x_pos: int, difficulty: String, stop_mid: bool = false):
	var question = falling_question_scene.instantiate()
	question.set_difficulty(difficulty)
	question.initialize(question_text, answer_int, stop_mid)
	question.position = Vector2(x_pos, 0)
	
	if not stop_mid:
		question.connect("question_failed", _on_question_failed.bind(question))

	question.connect("question_failed", _on_question_failed.bind(question))

	add_child(question)
	active_questions.append(question)

	if animation: # Checagem de segurança
		animation.play("Run_Up")

	print("Tutorial: Spawning '%s' com resposta '%s'" % [question_text, answer_int])

func generate_new_question() -> void:
	if tutorial_mode:
		return
		
	var operation = generator.generate_operation(selected_mode)
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

func update_score_label() -> void:
	score_label.text = "Acertos: %d" % current_score

func update_combo_label() -> void:
	combo_label.text = "Sequência: %d" % current_combo


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
			current_score += 1
			current_combo += 1
			update_combo_label()
			
			# ✅ CORREÇÃO: Não zerar o combo quando ganhar coração
			player_controller.addHeart_sequencia(current_combo)
			# ❌ REMOVER: current_combo = 0  (NÃO ZERE AQUI!)
			
			update_score_label()
			animation.play("Run_Down")

			update_ui("Correto!")
			if not player_controller.developer_mode:
				SaveManager.add_score(selected_mode)

			return  # Sai aqui porque acertou

	# Se chegou aqui, não acertou nenhuma operação:
	animation.play("Fall")
	wrong_or_miss.play()
	update_ui("Nenhuma operação corresponde.")
	if not player_controller.developer_mode:
		current_combo = 0  # ✅ Zerar combo só quando errar
		player_controller.reset_combo_goal()  # ✅ Resetar meta de combo
		update_combo_label()

	input_field.text = ""
	await get_tree().process_frame
	input_field.grab_focus()

	# ❌ REMOVER: current_errors += 1  (já é tratado no register_failure)
	# ❌ REMOVER: SaveManager.add_error(selected_mode)  (já é tratado no register_failure)

	animation.play("Run_Up")

func update_ui(message: String) -> void:
	if tutorial_mode:
		return
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
	if question in active_questions:
		active_questions.erase(question)
	update_ui("Uma conta caiu sem resposta!")
	if not player_controller.developer_mode:
		current_combo = 0
		update_combo_label()
		player_controller.register_failure()
		SaveManager.add_error(selected_mode)

func _on_fail_zone_body_entered(body) -> void:
	animation.play("Fall")
	wrong_or_miss.play()


	if body is CharacterBody2D and body.has_method("fail"):
		body.fail()

	if not player_controller.developer_mode:
		current_errors += 1
		current_combo = 0
		update_combo_label()
		SaveManager.add_error(selected_mode)


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
	Engine.time_scale = 1

	var scene = preload("res://scenes/gameplay/mode_gameplay.tscn").instantiate()
	scene.set_mode(selected_mode)
	scene.set_difficulty(selected_difficulty)
	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene


func _on_game_over() -> void:
	
	gameOver.play()
	SaveManager.add_high_score(current_score, current_errors, selected_mode)
	Engine.time_scale = 1
	update_ui("Game Over!")

	await get_tree().create_timer(1).timeout

	show_hint_screen()



func show_hint_screen() -> void:
	pause_menu.hide()
	healthbar.hide()
	paused = false
	Engine.time_scale = 0  # Pausa o jogo

	hint_scene.show_hint_for_mode(selected_mode)

	if not hint_scene.is_inside_tree():
		get_tree().root.add_child(hint_scene)




func _on_reiniciar_pressed() -> void:
	Engine.time_scale = 1
	get_tree().paused = false
	restart_game()

func _on_pause_pressed() -> void:
	pauseMenu()
