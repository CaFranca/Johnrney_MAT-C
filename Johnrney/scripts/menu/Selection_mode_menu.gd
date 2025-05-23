extends Control

# Pré-carrega a cena principal do modo de gameplay (jogo matemático)
var gameplay_scene = preload("res://scenes/gameplay/mode_gameplay.tscn")

# Referência ao efeito sonoro do clique do botão
@onready var button_click = $buttonclick

# Função chamada quando a cena é carregada e pronta
func _ready():
	# Espera um frame para garantir que a cena esteja estável antes de executar algo
	await get_tree().process_frame
	# Inicia a música relacionada ao menu de seleção
	MusicController.play_music_for("menu")

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
