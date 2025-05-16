extends Node2D  # Cena principal do gameplay

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
@onready var player_controller = $PlayerController

# Cena da pergunta que vai cair do topo
var falling_question_scene = preload("res://scenes/gameplay/FallingQuestion.tscn")

# Lista de perguntas ativas
var active_questions: Array = []

# Modo atual de operação matemática (ex: "add", "sub")
var selected_mode: String = "add"

func _ready():
	animation.play("Run_Up")
	MusicController.play_music_for("gameplay")
	randomize()

	fail_zone.body_entered.connect(_on_fail_zone_body_entered)
	player_controller.game_over.connect(_on_game_over)

	generate_new_question()
	spawn_timer.start()

func set_mode(mode: String):
	selected_mode = mode

func generate_new_question():
	var operation = generator.generate_operation(selected_mode)
	var question = falling_question_scene.instantiate()
	question.initialize(operation["question"], operation["answer"])
	question.position = Vector2(randi() % 400 + 100, 0)

	# Conecta o sinal de falha à função local
	question.connect("question_failed", _on_question_failed.bind(question))

	add_child(question)
	active_questions.append(question)

	animation.play("Run_Up")
	print("Operação gerada")
	update_ui("Responda a operação correta!")

func check_answer():
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
			q.collision_shape.disabled = true  # Desativa colisão da pergunta já respondida
			q.queue_free()
			active_questions.erase(q)
			input_field.text = ""

			await get_tree().process_frame
			input_field.grab_focus()

			correct_song.play()
			animation.play("Run_Down")
			update_ui("Correto!")
			return

	# Se nenhuma pergunta for respondida corretamente
	animation.play("Fall")
	wrong_or_miss.play()
	update_ui("Nenhuma operação corresponde.")
	input_field.text = ""

	await get_tree().process_frame
	input_field.grab_focus()

	player_controller.register_failure()

func update_ui(message: String):
	question_label.text = message
	input_field.grab_focus()

func _on_submit_button_pressed():
	check_answer()
	input_field.grab_focus()

func _on_input_field_for_answer_text_submitted(new_text):
	check_answer()
	input_field.grab_focus()

func _on_question_failed(question):
	active_questions.erase(question)
	update_ui("Uma conta caiu sem resposta!")
	player_controller.register_failure()

func _on_fail_zone_body_entered(body):
	animation.play("Fall")
	wrong_or_miss.play()
	print("Algo colidiu com a fail zone: ", body)

	if body is CharacterBody2D and body.has_method("fail"):
		body.fail()

func _on_spawn_timer_timeout():
	generate_new_question()

func _on_return_to_menu_pressed() -> void:
	$buttonclick.play()
	await $buttonclick.finished
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func _on_game_over():
	update_ui("Game Over!")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/menu/Selection_mode_menu.tscn")
