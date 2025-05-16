extends Node

@onready var player = $AudioStreamPlayer

var current_track_name := ""
var music_enabled := true

# Lista de músicas aleatórias para gameplay
var music_list = [
	"res://assets/audio/music/gameplay/Teste - MatC (3).mp3",
	"res://assets/audio/music/gameplay/Teste - MatC (4).mp3",
	"res://assets/audio/music/gameplay/Teste - MatC (5).mp3",
	"res://assets/audio/music/gameplay/Teste - MatC (6).mp3"
]

# Dicionário com trilhas fixas para outras cenas
var music_tracks = {
	"menu": preload("res://assets/audio/music/menu/main_menu.ogg")
}

func _ready():
	randomize()  # Garante aleatoriedade real

# Retorna uma música aleatória da lista
func get_random_music() -> AudioStream:
	var index = randi() % music_list.size()
	return load(music_list[index])

# Toca a música com base no nome da cena/modo
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
		push_warning("Música para '" + scene_name + "' não encontrada!")
		return

	player.stream = stream
	player.play()
	current_track_name = scene_name

# Ativa ou desativa a música globalmente
func toggle_music(enabled: bool) -> void:
	music_enabled = enabled
	if enabled:
		play_music_for(current_track_name)
	else:
		player.stop()

# Função opcional para controle de volume (descomentável)
# func slide_bar(value: float) -> void:
#     var bus_index = AudioServer.get_bus_index("Music")
#     if bus_index == -1:
#         push_error("Bus 'Music' não encontrado!")
#         return
#     AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
#     AudioServer.set_bus_mute(bus_index, value < 0.01)
