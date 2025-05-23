extends Control  # Script do menu principal do jogo

# ============================ #
# ======= VARIÁVEIS ========= #
# ============================ #

# Referência aos sons de clique e de hover
@onready var button_click = $buttonclick
@onready var hover_sound = $mouse_entered


func _ready() -> void:
	MusicController.play_music_for("menu")
	# Exemplo: ajustar volume conforme config salva
	MusicController.set_volume(SaveManager.settings.music_volume)



# ========================================= #
# === FUNÇÕES GENÉRICAS PARA SONS ========= #
# ========================================= #

# Função para tocar som de clique de botão
func play_click_sound() -> void:
	button_click.play()
	await button_click.finished


# Função para tocar som ao passar o mouse sobre os botões
func play_hover_sound() -> void:
	hover_sound.play()
	await hover_sound.finished


# ========================================= #
# ============ BOTÕES DE AÇÃO ============= #
# ========================================= #

# Botão "Start" (Iniciar Jogo)
func _on_start_pressed() -> void:
	print("Botão start clicado")  # Feedback opcional no console
	await play_click_sound()
	get_tree().change_scene_to_file("res://scenes/menu/Selection_mode_menu.tscn")


# Botão "Créditos"
func _on_credits_pressed() -> void:
	await play_click_sound()
	# Ação dos créditos (adicionar aqui se desejar)


# Botão "Sair"
func _on_quit_pressed() -> void:
	await play_click_sound()
	get_tree().quit()


# Botão "Opções"
func _on_options_pressed() -> void:
	await play_click_sound()
	get_tree().change_scene_to_file("res://scenes/menu/config/options.tscn")


# Botão do canal do YouTube
func _on_cavibezz_pressed() -> void:
	await play_click_sound()
	OS.shell_open("https://www.youtube.com/@CaVibezz")  # Abre o navegador no canal


# ============================================== #
# ============ EVENTOS DE HOVER ================= #
# ============================================== #

func _on_start_mouse_entered() -> void:
	await play_hover_sound()


func _on_credits_mouse_entered() -> void:
	await play_hover_sound()


func _on_quit_mouse_entered() -> void:
	await play_hover_sound()


func _on_options_mouse_entered() -> void:
	await play_hover_sound()


func _on_cavibezz_mouse_entered() -> void:
	await play_hover_sound()


# ======================================================== #
# === OPÇÃO EXTRA - Alternar música (comentado) ========= #
# ======================================================== #

# func _on_musica_toggled(toggled_on: bool) -> void:
# 	MusicController.toggle_music(toggled_on)
