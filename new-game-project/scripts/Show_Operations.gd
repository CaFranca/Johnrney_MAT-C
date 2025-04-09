extends Node2D

@onready var generator = $OperationGenerator
@onready var question_label = $QuestionLabel
@onready var input_field = $InputField
@onready var submit_button = $SubmitButton

var current_answer = 0

func _ready():
	randomize()
	generate_new_question()
	submit_button.pressed.connect(_on_submit_pressed)
	input_field.text_submitted.connect(_on_input_submitted)

func generate_new_question():
	var operation = generator.generate_operation()
	question_label.text = operation["question"]
	current_answer = operation["answer"]
	input_field.text = ""
	input_field.grab_focus()  # já foca no campo pra digitar

func _on_submit_pressed():
	check_answer()

func _on_input_submitted(new_text):
	check_answer()

func check_answer():
	if input_field.text.strip_edges() == "":
		return  # evita erro se estiver vazio

	var player_answer = int(input_field.text)
	if player_answer == current_answer:
		question_label.text = "Correto!"
	else:
		question_label.text = "Errado! Tente novamente."

	await get_tree().create_timer(1.5).timeout
	generate_new_question()
