extends Control

# Referência ao efeito sonoro de clique do botão (nó AudioStreamPlayer)
@onready var button_click = $buttonclick

# Executado quando a cena é carregada
func _ready() -> void:
	# Inicia a música correspondente à tela de menu
	MusicController.play_music_for("menu")

# Função chamada quando o botão "voltar" é pressionado
func _on_back_pressed() -> void:
	button_click.play()  # Toca o som de clique
	await button_click.finished  # Aguarda o término do som antes de continuar
	# Troca para a cena do menu principal
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

# Função chamada quando o mouse entra na área do botão "voltar"
func _on_back_mouse_entered() -> void:
	$mouse_entered.play()  # Toca som de hover
	await $mouse_entered.finished  # Aguarda o término do som

# Função chamada quando o toggle de música é ativado/desativado
#func _on_musics_toggled(toggled_on: bool) -> void:
#	# Ativa ou desativa a música conforme o estado do toggle
#	MusicController.toggle_music(toggled_on)

# Função chamada quando o slider de volume é modificado
func _on_music_volume_value_changed(value) -> void:
	# Ajusta o volume da música com base no valor do slider (espera-se valor entre 0.0 e 1.0)
	MusicController.slide_bar(value)

# Função chamada quando um item de resolução é selecionado no menu suspenso
func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			# Define a janela para resolução Full HD (1920x1080)
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			# Define a janela para resolução HD+ (1600x900)
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			# Define a janela para resolução HD (1280x720)
			DisplayServer.window_set_size(Vector2i(1280, 720))
