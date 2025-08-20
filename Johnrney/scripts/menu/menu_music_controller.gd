extends Node  # Controlador global de músicas do jogo

# ============================ #
# ========= VARIÁVEIS ========= #
# ============================ #

@onready var player = $AudioStreamPlayer  # Referência ao player de áudio

var current_track_name := ""   # Nome da trilha atualmente tocando
var music_enabled := true      # Controla se a música está ativada

# ---------------------------- #
# Playlists de músicas por local/mode/dificuldade
# ---------------------------- #

# Exemplo: Playlist do menu (pode ter múltiplas músicas)
var playlist_menu = [
	preload("res://assets/audio/music/menu/C418 - Sweden (Trap Remix) (mp3cut.net).ogg"),
	preload("res://assets/audio/music/menu/main_menu_2.ogg"),
	preload("res://assets/audio/music/menu/main_menu.ogg"),
	preload("res://assets/audio/music/menu/Wet Hands.ogg"),
	preload("res://assets/audio/music/menu/main_menu3.ogg")
	
	# Adicione outras faixas aqui, preload para otimizar
]

var playlist_gameplay = [preload("res://assets/audio/music/gameplay/Teste - MatC (3).mp3"),
 	preload("res://assets/audio/music/gameplay/Teste - MatC (4).mp3"),
 	preload("res://assets/audio/music/gameplay/Teste - MatC (6).mp3"),
 	preload("res://assets/audio/music/gameplay/Teste - MatC (5).mp3")
]

# Gameplay subdividido por modos com playlists específicas
# var playlist_gameplay_soma = [
# 	preload("res://assets/audio/music/soma/track1.ogg"),
# 	preload("res://assets/audio/music/soma/track2.ogg")
# ]

# var playlist_gameplay_subtracao = [
# 	preload("res://assets/audio/music/subtracao/track1.ogg"),
# 	preload("res://assets/audio/music/subtracao/track2.ogg")
# ]

# var playlist_gameplay_multiplicacao = [
# 	preload("res://assets/audio/music/multiplicacao/track1.ogg"),
# 	preload("res://assets/audio/music/multiplicacao/track2.ogg")
# ]

# var playlist_gameplay_divisao = [
# 	preload("res://assets/audio/music/divisao/track1.ogg"),
# 	preload("res://assets/audio/music/divisao/track2.ogg")
# ]


# Se quiser, pode criar playlists para outras situações/dificuldades aqui
# var playlist_gameplay_facil = [...]
# var playlist_gameplay_medio = [...]
# var playlist_gameplay_dificil = [...]

# ============================== #
# Variáveis para controle interno
# ============================== #

var current_mode := ""  # Exemplo: "menu", "gameplay_soma", "gameplay_subtracao", etc.

# ============================== #
# ====== FUNÇÕES DE CICLO ====== #
# ============================== #

func _ready() -> void:
	randomize()
	player.connect("finished", Callable(self, "_on_music_finished"))

# ============================== #
# Função para obter playlist conforme o modo atual
# ============================== #

func get_playlist_for_mode(mode: String) -> Array:
	match mode:
		"menu":
			return playlist_menu
		"gameplay":
			return playlist_gameplay
# 		"gameplay_soma":
# 			return playlist_gameplay_soma
# 		"gameplay_subtracao":
# 			return playlist_gameplay_subtracao
# 		"gameplay_multiplicacao":
# 			return playlist_gameplay_multiplicacao
# 		"gameplay_divisao":
# 			return playlist_gameplay_divisao
 		# Aqui você pode colocar mais modos, dificuldades, locais etc.

		_:
			return []  # Vazio se não encontrar playlist

# ============================== #
# Função para pegar música aleatória da playlist
# ============================== #

func get_random_track_from_playlist(playlist: Array) -> AudioStream:
	if playlist.size() == 0:
		return null

	var index = randi() % playlist.size()
	return playlist[index]

# ============================== #
# Função para tocar música baseada no modo/local
# ============================== #

func play_music_for(mode: String) -> void:
	if not music_enabled:
		player.stop()
		return

	# Se já está tocando música para esse modo, não faz nada
	if current_track_name == mode and player.playing:
		return

	var playlist = get_playlist_for_mode(mode)
	if playlist.size() == 0:
		push_warning("Playlist vazia ou modo '" + mode + "' desconhecido!")
		player.stop()
		return

	var track = get_random_track_from_playlist(playlist)
	if track == null:
		push_warning("Falha ao carregar a música para o modo: " + mode)
		player.stop()
		return

	player.stream = track
	player.play()
	current_track_name = mode
	current_mode = mode  # Guarda para reusar em _on_music_finished()

# ============================== #
# Quando a música termina, toca outra da mesma playlist (aleatório)
# ============================== #

func _on_music_finished() -> void:
	if music_enabled and current_mode != "":
		play_music_for(current_mode)

# ============================== #
# Ativa ou desativa música (ex: nas opções)
# ============================== #

func toggle_music(enabled: bool) -> void:
	music_enabled = enabled
	if enabled:
		play_music_for(current_mode)
	else:
		player.stop()

# ============================== #
# Controle de volume
# ============================== #

func set_volume(volume: float) -> void:
	var bus_index = AudioServer.get_bus_index("music")
	if bus_index == -1:
		push_error("Bus 'music' não encontrado!")
		return
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	AudioServer.set_bus_mute(bus_index, volume <= 0.01)
