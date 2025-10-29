extends Control  # Script do menu principal do jogo

# ============================ #
# ======= VARIÁVEIS ========= #
# ============================ #

# Sons
@onready var button_click = $buttonclick
@onready var hover_sound = $mouse_entered

# Animação de fundo
@onready var background_animation = $BackgroundAnimation # AnimatedSprite2D

# Nome das animações do fundo para cada botão
const BG_ANIMATIONS = {
	"start": "start_bg",
	"credits": "credits_bg",
	"options": "options_bg",
	"quit": "quit_bg",
	"cavibezz": "youtube_bg",
	"idle": "idle_bg"
}

func _ready() -> void:
	MusicController.play_music_for("menu")
	MusicController.set_volume(float(SaveManager.load_setting("music_volume", 1.0)))
	
	if SaveManager.checked_tutorial_this_session:
		return
	
	SaveManager.checked_tutorial_this_session = true
	if SaveManager.is_tutorial_complete() == false:
		print("Primeira vez! Iniciando tutorial...")
		get_tree().change_scene_to_file("res://scenes/gameplay/Tutorial.tscn")
	# Inicia com idle

	
# ========================================= #
# === FUNÇÕES GENÉRICAS PARA SONS ========= #
# ========================================= #

func play_click_sound() -> void:
	button_click.play()
	await button_click.finished

func play_hover_sound() -> void:
	hover_sound.play()
	await hover_sound.finished


# ========================================= #
# ============ BOTÕES DE AÇÃO ============= #
# ========================================= #

func _on_start_pressed() -> void:
	await play_click_sound()

	get_tree().change_scene_to_file("res://scenes/menu/Selection_mode_menu.tscn")

func _on_credits_pressed() -> void:
	await play_click_sound()

	get_tree().change_scene_to_file("res://scenes/menu/creditos_.tscn")

func _on_quit_pressed() -> void:
	await play_click_sound()

	get_tree().quit()

func _on_options_pressed() -> void:
	await play_click_sound()
	
	get_tree().change_scene_to_file("res://scenes/menu/config/options.tscn")
	
func _on_tutorial_pressed() -> void:
	await play_click_sound()
	
	get_tree().change_scene_to_file("res://scenes/gameplay/Tutorial.tscn")

func _on_cavibezz_pressed() -> void:
	await play_click_sound()
	
	OS.shell_open("https://www.youtube.com/@CaVibezz")


# ============================================== #
# ============ EVENTOS DE HOVER ================= #
# ============================================== #

func _on_start_mouse_entered() -> void:
	await play_hover_sound()
	background_animation.play(BG_ANIMATIONS["start"])
	

func _on_start_mouse_exited() -> void:
	background_animation.play(BG_ANIMATIONS["idle"])
	


func _on_credits_mouse_entered() -> void:
	await play_hover_sound()
	background_animation.play(BG_ANIMATIONS["credits"])
	

func _on_credits_mouse_exited() -> void:
	background_animation.play(BG_ANIMATIONS["idle"])



func _on_quit_mouse_entered() -> void:
	await play_hover_sound()
	background_animation.play(BG_ANIMATIONS["quit"])


func _on_quit_mouse_exited() -> void:
	background_animation.play(BG_ANIMATIONS["idle"])
	


func _on_options_mouse_entered() -> void:
	await play_hover_sound()
	background_animation.play(BG_ANIMATIONS["options"])


func _on_options_mouse_exited() -> void:
	background_animation.play(BG_ANIMATIONS["idle"])



func _on_cavibezz_mouse_entered() -> void:
	await play_hover_sound()
	background_animation.play(BG_ANIMATIONS["cavibezz"])


func _on_cavibezz_mouse_exited() -> void:
	background_animation.play(BG_ANIMATIONS["idle"])


func _on_tutorial_mouse_entered() -> void:
	pass # colocar o código pra inserir o sprite do tutorial


func _on_tutorial_mouse_exited() -> void:
	background_animation.play(BG_ANIMATIONS["idle"])
	
