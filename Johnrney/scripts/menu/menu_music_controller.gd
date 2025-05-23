extends Node  # Controlador global de músicas do jogo

# ============================ #
# ========= VARIÁVEIS ========= #
# ============================ #

# Referência ao player de áudio que executa as músicas
@onready var player = $AudioStreamPlayer

# Guarda o nome da trilha atualmente tocando
var current_track_name := ""

# Controla se a música está ativada ou desativada
var music_enabled := true


# 🎵 Lista de músicas para gameplay (tocam de forma aleatória)
var music_list = [
	"res://assets/audio/music/gameplay/Teste - MatC (3).mp3",
	"res://assets/audio/music/gameplay/Teste - MatC (4).mp3",
	"res://assets/audio/music/gameplay/Teste - MatC (5).mp3",
	"res://assets/audio/music/gameplay/Teste - MatC (6).mp3"
]

# 🎵 Dicionário com músicas fixas para menus ou outras cenas
var music_tracks = {
	"menu": preload("res://assets/audio/music/menu/C418 - Sweden (Trap Remix) (mp3cut.net).ogg")
}


# ============================== #
# ====== FUNÇÕES DE CICLO ====== #
# ============================== #

func _ready() -> void:
	# Garante que a seleção aleatória seja de fato randômica
	randomize()


# ================================================ #
# ====== FUNÇÃO PARA PEGAR UMA MÚSICA RANDOM ====== #
# ================================================ #

func get_random_music() -> AudioStream:
	# Seleciona um índice aleatório dentro da lista de músicas de gameplay
	var index = randi() % music_list.size()
	# Carrega e retorna a música selecionada
	return load(music_list[index])


# ===================================================== #
# ====== FUNÇÃO CENTRAL PARA TOCAR A MÚSICA ========== #
# ===================================================== #

func play_music_for(scene_name: String) -> void:
	# Se a música estiver desligada, para qualquer reprodução e sai
	if not music_enabled:
		player.stop()
		return

	# Se já estiver tocando a música desta cena, não faz nada
	if current_track_name == scene_name and player.playing:
		return

	# Variável temporária para armazenar o stream de áudio
	var stream: AudioStream = null

	# Se for gameplay, pega uma música aleatória
	if scene_name == "gameplay":
		stream = get_random_music()

	# Se for uma cena com música específica (como menu), pega do dicionário
	elif music_tracks.has(scene_name):
		stream = music_tracks[scene_name]

	# Se não encontrar nenhuma música correspondente, exibe aviso e sai
	else:
		push_warning("⚠️ Música para '" + scene_name + "' não encontrada!")
		return

	# Define a música no player
	player.stream = stream

	# 🔄 Verifica e ativa loop, se suportado
	if player.stream is AudioStream:
		if player.stream.has_loop():
			player.stream.set_loop(true)
		# 🔧 OBS: MP3 normalmente não suporta loop nativo.
		# Se quiser, aqui poderia ser implementado um sistema de loop manual para esses casos.

	# Começa a tocar a música
	player.play()

	# Atualiza o nome da trilha atual
	current_track_name = scene_name


# ======================================================= #
# ==== ATIVA OU DESATIVA A MÚSICA (USADO EM OPÇÕES) ==== #
# ======================================================= #

func toggle_music(enabled: bool) -> void:
	music_enabled = enabled

	if enabled:
		# Retoma a música atual quando liga novamente
		play_music_for(current_track_name)
	else:
		# Para a música imediatamente quando desliga
		player.stop()


# ========================================================== #
# ==== CONTROLE DE VOLUME - OPCIONAL (DESCOMENTAR) ======== #
# ========================================================== #

# func slide_bar(value: float) -> void:
#     var bus_index = AudioServer.get_bus_index("Music")
#     if bus_index == -1:
#         push_error("Bus 'Music' não encontrado!")
#         return
#
#     AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
#     AudioServer.set_bus_mute(bus_index, value < 0.01)
