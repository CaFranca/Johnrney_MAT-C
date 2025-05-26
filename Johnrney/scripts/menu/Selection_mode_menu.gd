extends Control

# Pré-carrega a cena principal do modo de gameplay (jogo matemático)
var gameplay_scene = preload("res://scenes/gameplay/mode_gameplay.tscn")

# Referência ao efeito sonoro do clique do botão
@onready var button_click = $buttonclick

# Dicionário que associa cada modo ao seu respectivo Label na interface
@onready var score_labels = {
	"add": $MarginContainer/HBoxContainer/VBoxContainer/sum_rank,
	"sub": $MarginContainer/HBoxContainer/VBoxContainer/minus_rank,
	"mul": $MarginContainer/HBoxContainer/VBoxContainer/times_rank,
	"div": $MarginContainer/HBoxContainer/VBoxContainer/div_rank,
	"all": $MarginContainer/HBoxContainer/VBoxContainer/all_rank
}

# Executado quando a cena é carregada
func _ready():
	# Garante que a árvore de nós esteja totalmente processada
	await get_tree().process_frame
	# Inicia a música do menu
	MusicController.play_music_for("menu")
	# Atualiza os rankings exibidos na tela
	update_score_labels()

# Atualiza os Labels de ranking para cada modo
func update_score_labels():
	for mode in score_labels.keys():
		score_labels[mode].text = format_high_scores(mode)

# Formata o texto de exibição dos rankings de acordo com os dados salvos
func format_high_scores(mode: String) -> String:
	var scores = SaveManager.get_top_scores_for_mode(mode)
	var text = "Top 5 no modo: %s\n" % mode

	# Caso não haja registros
	if scores.size() == 0:
		return text + "Sem registros ainda."

	# Formata os 5 melhores scores (ou menos se não houver 5)
	for i in range(min(scores.size(), 5)):
		var entry = scores[i]
		var acerto_palavra = "acerto" if entry["score"] == 1 else "acertos"
		var erro_palavra = "erro" if entry["errors"] == 1 else "erros"
		var timestamp = entry.get("timestamp", "")

		text += "%dº - %d %s (%d %s)" % [
			i + 1,
			entry["score"],
			acerto_palavra,
			entry["errors"],
			erro_palavra
		]

		if timestamp != "":
			text += " - " + timestamp

		text += "\n"

	return text

# Função que instancia o jogo no modo selecionado
func _start_game_with_mode(mode: String) -> void:
	await _play_button_click()
	var scene_instance = gameplay_scene.instantiate()
	scene_instance.set_mode(mode)
	get_tree().root.add_child(scene_instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene_instance

# Função auxiliar que toca o som de clique e espera ele terminar
func _play_button_click():
	button_click.play()
	return button_click.finished

# Funções dos botões de seleção de modo
func _on_sum_pressed() -> void:
	await _start_game_with_mode("add")

func _on_minus_pressed() -> void:
	await _start_game_with_mode("sub")

func _on_times_pressed() -> void:
	await _start_game_with_mode("mul")

func _on_div_pressed() -> void:
	await _start_game_with_mode("div")

func _on_all_pressed() -> void:
	await _start_game_with_mode("all")

# Função do botão de voltar ao menu principal
func _on_back_pressed() -> void:
	await _play_button_click()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
