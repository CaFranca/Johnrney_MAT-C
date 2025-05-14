extends Control

# Pré-carrega a cena principal de gameplay
var gameplay_scene = preload("res://scenes/gameplay/mode_gameplay.tscn")

# Referência ao efeito sonoro de clique
@onready var button_click = $buttonclick

# Executado ao iniciar a cena
func _ready():
	await get_tree().process_frame  # Espera o primeiro frame para evitar conflitos
	MusicController.play_music_for("selection")  # Toca a música correspondente à tela de seleção

# Função que inicia o jogo com o modo matemático selecionado
func _start_game_with_mode(mode: String) -> void:
	button_click.play()  # Toca o som de clique
	await button_click.finished  # Espera o som terminar

	var scene_instance = gameplay_scene.instantiate()  # Cria uma instância da cena de gameplay
	scene_instance.set_mode(mode)  # Define o modo de operação matemática (soma, subtração, etc.)
	get_tree().root.add_child(scene_instance)  # Adiciona a nova cena ao nó raiz
	get_tree().current_scene.queue_free()  # Remove a cena atual
	get_tree().current_scene = scene_instance  # Define a nova cena como atual

# Chamado ao clicar no botão de soma
func _on_sum_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("add")  # Inicia o jogo no modo de adição

# Chamado ao clicar no botão de subtração
func _on_minus_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("sub")

# Chamado ao clicar no botão de multiplicação
func _on_times_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("mul")

# Chamado ao clicar no botão de divisão
func _on_div_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("div")

# Chamado ao clicar no botão de todos os modos misturados
func _on_all_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("all")

# Chamado ao clicar no botão de voltar ao menu principal
func _on_back_pressed() -> void:
	button_click.play()
	await button_click.finished
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

# Comentado: opção para alternar a música
#func _on_Musica_toggled(toggled_on: bool) -> void:
#	MusicController.toggle_music(toggled_on)
