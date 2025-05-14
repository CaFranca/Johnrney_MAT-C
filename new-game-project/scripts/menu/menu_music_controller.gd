extends Node  # Este nó gerencia a reprodução de músicas de fundo no jogo

# Referência ao nó de reprodução de áudio
@onready var player = $AudioStreamPlayer

# Nome da faixa atual tocando
var current_track_name := ""

# Controle global para ativar/desativar a música
var music_enabled := true

# Dicionário que associa nomes de cenas/modos a arquivos de áudio
var music_tracks = {
	"menu": preload("res://assets/audio/music/menu/main_menu.ogg"),
	"selection": preload("res://assets/audio/music/gameplay/Teste - MatC (3).mp3"),
	"gameplay": preload("res://assets/audio/music/gameplay/Teste - MatC (5).mp3")
}

# Toca a música correspondente ao nome da cena/modo passado como argumento
func play_music_for(scene_name: String) -> void:
	# Se a música estiver desativada, para o player
	if not music_enabled:
		player.stop()
		return

	# Se a música atual já for a certa e estiver tocando, não faz nada
	if current_track_name == scene_name and player.playing:
		return

	# Se existe uma faixa correspondente, toca
	if music_tracks.has(scene_name):
		player.stream = music_tracks[scene_name]  # Define a faixa de áudio
		player.play()  # Inicia a reprodução
		current_track_name = scene_name  # Atualiza o nome da faixa atual
	else:
		push_warning("Música para '" + scene_name + "' não encontrada!")  # Alerta no console caso a chave não exista

# Liga ou desliga a música globalmente
func toggle_music(enabled: bool) -> void:
	music_enabled = enabled
	if music_enabled:
		play_music_for(current_track_name)  # Retoma a música atual se ativado
	else:
		player.stop()  # Para a reprodução se desativado

# Define o volume da música via Audio Bus chamado "Music"
#func slide_bar(value: float) -> void:
#	var bus_index = AudioServer.get_bus_index("Music")  # Busca o índice do bus de música
#	if bus_index == -1:
#		push_error("Bus 'Music' não encontrado!")  # Exibe erro se o bus não existir
#		return
#	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))  # Converte valor linear em dB e aplica
#	AudioServer.set_bus_mute(bus_index, value < 0.01)  # Silencia se o valor for muito baixo
