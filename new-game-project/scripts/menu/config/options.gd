extends Control

# Referência ao efeito sonoro de clique do botão
@onready var button_click = $buttonclick

# Quando a cena é carregada, toca a música correspondente ao menu
func _ready() -> void:
	MusicController.play_music_for("menu")

# Quando o botão "voltar" é pressionado
func _on_back_pressed() -> void:
	button_click.play()  # Toca som de clique
	await button_click.finished  # Espera o som terminar
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")  # Volta para o menu principal

# Quando o mouse passa por cima do botão "voltar"
func _on_back_mouse_entered() -> void:
	$mouse_entered.play()  # Toca som de mouse hover
	await $mouse_entered.finished  # Espera o som terminar

# Quando a música é ativada ou desativada no botão de alternância
func _on_musics_toggled(toggled_on: bool) -> void:
	MusicController.toggle_music(toggled_on)  # Ativa ou desativa a música com base no estado

# Quando o volume da música é alterado via slider
func _on_music_volume_value_changed(value) -> void:
	MusicController.slide_bar(value)  # Ajusta o volume da música com base no valor do slider

# Quando uma resolução é selecionada no menu suspenso
func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))  # Define para Full HD
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))   # Define para HD+
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))   # Define para HD
