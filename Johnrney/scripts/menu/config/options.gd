extends Control  # Esta cena herda de Control, um tipo de nó usado para interfaces gráficas

# Busca o node chamado "buttonclick" e guarda na variável button_click após a cena estar pronta
@onready var button_click = $buttonclick

func _ready() -> void:
	# Quando o nó estiver pronto, chama o MusicController para tocar a música do menu
	MusicController.play_music_for("menu")

# Função chamada quando o botão "voltar" é pressionado
func _on_back_pressed() -> void:
	button_click.play()        # Toca o som de clique
	await button_click.finished  # Espera o som terminar para continuar
	# Troca para a cena do menu principal
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

# Função chamada quando o mouse entra sobre o botão "voltar"
func _on_back_mouse_entered() -> void:
	$mouse_entered.play()         # Toca um som de mouse entrando no botão
	await $mouse_entered.finished # Espera o som terminar antes de continuar (se necessário)

# Função chamada quando um item da lista de resoluções é selecionado (index é a posição selecionada)
func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			# Define a janela para resolução Full HD
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			SaveManager.settings.resolution = "1920x1080"  # Atualiza a configuração no SaveManager
		1:
			# Define a janela para resolução 1600x900
			DisplayServer.window_set_size(Vector2i(1600, 900))
			SaveManager.settings.resolution = "1600x900"
		2:
			# Define a janela para resolução HD
			DisplayServer.window_set_size(Vector2i(1280, 720))
			SaveManager.settings.resolution = "1280x720"

	# Após alterar a resolução, salva as configurações atualizadas
	SaveManager.save_settings()


func _on_clear_data_pressed() -> void:
	SaveManager.clear_high_scores()


func _on_clear_data_mouse_entered() -> void:
	$mouse_entered.play()         # Toca um som de mouse entrando no botão
	await $mouse_entered.finished # Espera o som terminar antes de continuar (se necessário)
