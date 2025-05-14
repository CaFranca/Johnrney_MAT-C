extends Control  # Este script está anexado a um nó de interface (menu principal do jogo)

# Referência ao som de clique do botão
@onready var button_click = $buttonclick

func _ready() -> void:
	# Toca a música apropriada para a cena atual (neste caso, "menu")
	MusicController.play_music_for("menu")  # Pode ser alterado para "selection", "gameplay", etc.

	pass  # Placeholder, pode ser removido

# Quando o botão "Start" for pressionado
func _on_start_pressed() -> void:
	print("Botão start clicado")  # Mensagem no console
	button_click.play()  # Toca o som de clique
	await button_click.finished  # Espera o som terminar
	get_tree().change_scene_to_file("res://scenes/menu/Selection_mode_menu.tscn")  # Muda para a próxima cena

# Quando o botão "Créditos" for pressionado
func _on_credits_pressed() -> void:
	button_click.play()
	await button_click.finished
	# A ação relacionada aos créditos pode ser adicionada aqui

# Quando o botão "Sair" for pressionado
func _on_quit_pressed() -> void:
	button_click.play()
	await button_click.finished
	get_tree().quit()  # Fecha o jogo

# Quando o cursor entra no botão "Start"
func _on_start_mouse_entered() -> void:
	$mouse_entered.play()
	await $mouse_entered.finished

# Quando o cursor entra no botão "Créditos"
func _on_credits_mouse_entered() -> void:
	$mouse_entered.play()
	await $mouse_entered.finished

# Quando o cursor entra no botão "Sair"
func _on_quit_mouse_entered() -> void:
	$mouse_entered.play()
	await $mouse_entered.finished

# Quando o botão com link para o canal do YouTube for pressionado
func _on_cavibezz_pressed() -> void:
	button_click.play()
	await button_click.finished
	OS.shell_open("https://www.youtube.com/@CaVibezz")  # Abre o link no navegador

# Quando o cursor entra no botão do canal
func _on_cavibezz_mouse_entered() -> void:
	$mouse_entered.play()
	await $mouse_entered.finished

# Botão de opções do menu
func _on_options_pressed() -> void:
	button_click.play()
	await button_click.finished
	get_tree().change_scene_to_file("res://scenes/menu/config/options.tscn")  # Vai para a tela de opções

# Cursor entra no botão de opções
func _on_options_mouse_entered() -> void:
	$mouse_entered.play()
	await $mouse_entered.finished

# Comentado: opção para alternar música (caso deseje implementar no futuro)
# func _on_musica_toggled(toggled_on: bool) -> void:
# 	MusicController.toggle_music(toggled_on)
