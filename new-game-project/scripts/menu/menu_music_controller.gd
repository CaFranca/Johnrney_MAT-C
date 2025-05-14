extends Node

@onready var player = $AudioStreamPlayer

var current_track_name := ""
var music_enabled := true

# Mapeamento de cenas/modos para arquivos de áudio
var music_tracks = {
	"menu": preload("res://assets/audio/music/menu/main_menu.ogg"),
	"selection": preload("res://assets/audio/music/gameplay/Teste - MatC (3).mp3"),
	"gameplay": preload("res://assets/audio/music/gameplay/Teste - MatC (5).mp3")
}

# Reproduz a música correspondente ao nome da cena/modo
func play_music_for(scene_name: String) -> void:
	if not music_enabled:
		player.stop()
		return

	if current_track_name == scene_name and player.playing:
		return  # Já está tocando a música certa

	if music_tracks.has(scene_name):
		player.stream = music_tracks[scene_name]
		player.play()
		current_track_name = scene_name
	else:
		push_warning("Música para '" + scene_name + "' não encontrada!")

# Ativa ou desativa a música globalmente
func toggle_music(enabled: bool) -> void:
	music_enabled = enabled
	if music_enabled:
		play_music_for(current_track_name)
	else:
		player.stop()

# Define o volume da música através do Audio Bus "Music"
func slide_bar(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index == -1:
		push_error("Bus 'Music' não encontrado!")
		return
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)
