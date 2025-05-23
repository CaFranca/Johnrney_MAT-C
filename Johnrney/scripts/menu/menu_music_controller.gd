extends Node  # Controlador global de músicas do jogo

# ============================ #
# ========= VARIÁVEIS ========= #
# ============================ #

@onready var player = $AudioStreamPlayer  # Referência ao player de áudio

var current_track_name := ""   # Nome da trilha atualmente tocando
var music_enabled := true      # Controla se a música está ativada

# 🎵 Lista de músicas aleatórias para gameplay
var music_list = [
	"res://assets/audio/music/gameplay/Teste - MatC (3).mp3",
	"res://assets/audio/music/gameplay/Teste - MatC (4).mp3",
	"res://assets/audio/music/gameplay/Teste - MatC (5).mp3",
	"res://assets/audio/music/gameplay/Teste - MatC (6).mp3"
]

# 🎵 Dicionário de músicas fixas (ex.: menu)
var music_tracks = {
	"menu": preload("res://assets/audio/music/menu/C418 - Sweden (Trap Remix) (mp3cut.net).ogg")
}

# ============================== #
# ====== FUNÇÕES DE CICLO ====== #
# ============================== #

func _ready() -> void:
	randomize()

# ================================================ #
# ====== PEGA UMA MÚSICA RANDOM DE GAMEPLAY ====== #
# ================================================ #

func get_random_music() -> AudioStream:
	var index = randi() % music_list.size()
	return load(music_list[index])

# ===================================================== #
# ====== FUNÇÃO CENTRAL PARA TOCAR A MÚSICA ========== #
# ===================================================== #

func play_music_for(scene_name: String) -> void:
	if not music_enabled:
		player.stop()
		return

	if current_track_name == scene_name and player.playing:
		return

	var stream: AudioStream = null

	if scene_name == "gameplay":
		stream = get_random_music()
	elif music_tracks.has(scene_name):
		stream = music_tracks[scene_name]
	else:
		push_warning("⚠️ Música para '" + scene_name + "' não encontrada!")
		return

	player.stream = stream

	if player.stream is AudioStream:
		if player.stream.has_loop():
			player.stream.set_loop(true)

	player.play()
	current_track_name = scene_name

# ======================================================= #
# ==== ATIVA OU DESATIVA A MÚSICA (USADO EM OPÇÕES) ==== #
# ======================================================= #

func toggle_music(enabled: bool) -> void:
	music_enabled = enabled

	if enabled:
		play_music_for(current_track_name)
	else:
		player.stop()

# ========================================================== #
# ================= CONTROLE DE VOLUME ===================== #
# ========================================================== #

func set_volume(volume: float) -> void:
	# Volume de 0.0 (mudo) até 1.0 (máximo)
	var bus_index = AudioServer.get_bus_index("music")
	if bus_index == -1:
		push_error("Bus 'Music' não encontrado!")
		return

	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	AudioServer.set_bus_mute(bus_index, volume <= 0.01)  # Opcional: muta se estiver muito baixo
