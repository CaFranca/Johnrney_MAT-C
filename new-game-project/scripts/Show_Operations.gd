extends Node2D

@onready var generator = $OperationGenerator
@onready var question_label = $QuestionLabel
@onready var input_field = $InputField_for_answer
@onready var submit_button = $SubmitButton

var falling_question_scene = preload("res://scenes/FallingQuestion.tscn")
var active_questions: Array = []

func _ready():
	print("InputField:", input_field)
	print("QuestionLabel:", question_label)
	print("SubmitButton:", submit_button)
	print("OperationGenerator:", generator)
	randomize()
	generate_new_question()
	submit_button.pressed.connect(_on_submit_button_pressed)
	input_field.text_submitted.connect(_on_input_field_for_answer_text_submitted)

# Gera uma nova operação e instancia a pergunta na cena
func generate_new_question():
	var operation = generator.generate_operation()
	var question = falling_question_scene.instantiate()
	question.question = operation["question"]
	question.answer = operation["answer"]
	question.position = Vector2(randi() % 400 + 100, 0)  # X aleatório

	question.connect("question_failed", _on_question_failed.bind(question))
	add_child(question)
	active_questions.append(question)

	update_ui('Responda a operação correta!')

# Verifica se a resposta do jogador está correta
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
			q.queue_free()
			active_questions.erase(q)
			input_field.text = ""
			
			await get_tree().process_frame  # Espera 1 frame
			input_field.grab_focus()        # Reaplica o foco mantem o local de envio selecionado
			
			update_ui("Correto!")
			return

	update_ui("Nenhuma operação corresponde.")
	input_field.text = ""

	# Garantir que o foco seja reaplicado após o envio da resposta incorreta
	await get_tree().process_frame  # Espera 1 frame
	input_field.grab_focus()

# Utilitário para atualizar a interface
func update_ui(message: String):
	question_label.text = message
	# Garantir que o foco seja reaplicado sempre que a interface for atualizada
	input_field.grab_focus()

# Sinais

func _on_submit_button_pressed():
	check_answer()
	# Garantir que o foco seja reaplicado sempre que o botão for pressionado
	input_field.grab_focus()

func _on_input_field_for_answer_text_submitted(new_text):
	check_answer()
	# Garantir que o foco seja reaplicado após pressionar "Enter"
	input_field.grab_focus()

func _on_question_failed(question):
	active_questions.erase(question)
	update_ui("Uma conta caiu sem resposta!")

func _on_spawn_timer_timeout():
	generate_new_question()

func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
