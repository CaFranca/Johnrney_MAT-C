extends Control

# Pré-carrega a cena principal do modo de gameplay (jogo matemático)
var gameplay_scene = preload("res://scenes/gameplay/mode_gameplay.tscn")

# Referência ao efeito sonoro do clique do botão
@onready var button_click = $buttonclick
# Referências aos Labels que mostram os melhores scores de cada modo
@onready var add_score_label =$MarginContainer/HBoxContainer/VBoxContainer/sum_rank
@onready var sub_score_label = $MarginContainer/HBoxContainer/VBoxContainer/minus_rank
@onready var mul_score_label = $MarginContainer/HBoxContainer/VBoxContainer/times_rank
@onready var div_score_label = $MarginContainer/HBoxContainer/VBoxContainer/div_rank
@onready var all_score_label = $MarginContainer/HBoxContainer/VBoxContainer/all_rank

# Função chamada quando a cena é carregada e pronta
func _ready():
	await get_tree().process_frame
	MusicController.play_music_for("menu")
	update_score_labels()

func update_score_labels():
	add_score_label.text = format_high_scores("add")
	sub_score_label.text = format_high_scores("sub")
	mul_score_label.text = format_high_scores("mul")
	div_score_label.text = format_high_scores("div")
	all_score_label.text = format_high_scores("all")

func format_high_scores(mode: String) -> String:
	var scores = SaveManager.get_top_scores_for_mode(mode)
	var text = "Top 5 no modo: " + mode + "\n"

	for i in range(min(scores.size(), 5)):
		var entry = scores[i]
		var acerto_palavra = "acerto" if entry["score"] == 1 else "acertos"
		var erro_palavra = "erro" if entry["errors"] == 1 else "erros"

		var timestamp = entry.get("timestamp", "")  # pega direto o timestamp

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

	if scores.size() == 0:
		text += "Sem registros ainda."

	return text


# Função que inicia a gameplay com o modo matemático selecionado
func _start_game_with_mode(mode: String) -> void:
	button_click.play()  # Toca o som de clique para feedback
	await button_click.finished  # Aguarda o término do som para evitar sobreposição

	# Instancia a cena do jogo
	var scene_instance = gameplay_scene.instantiate()
	# Define o modo do jogo (add, sub, mul, div, all) na cena de gameplay
	scene_instance.set_mode(mode)
	# Adiciona a nova cena ao nó raiz da árvore de cenas
	get_tree().root.add_child(scene_instance)
	# Remove a cena atual para liberar memória
	get_tree().current_scene.queue_free()
	# Atualiza a referência da cena atual para a nova instância
	get_tree().current_scene = scene_instance

# Funções chamadas quando cada botão correspondente a um modo é pressionado
func _on_sum_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("add")  # Inicia no modo soma

func _on_minus_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("sub")  # Inicia no modo subtração

func _on_times_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("mul")  # Inicia no modo multiplicação

func _on_div_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("div")  # Inicia no modo divisão

func _on_all_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("all")  # Inicia com todos os modos misturados

# Função chamada ao pressionar o botão de voltar ao menu principal
func _on_back_pressed() -> void:
	button_click.play()
	await button_click.finished
	# Troca a cena para o menu principal
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")



# Comentado: exemplo de função para alternar música via botão toggle
# func _on_Musica_toggled(toggled_on: bool) -> void:
#	MusicController.toggle_music(toggled_on)
