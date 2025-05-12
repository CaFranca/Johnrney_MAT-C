extends Node

var music_enabled := true
@onready var player = $AudioStreamPlayer

func toggle_music(enabled: bool) -> void:
	music_enabled = enabled
	if music_enabled:
		if not player.playing:
			player.play()
	else:
		player.stop()

func play_music_if_enabled():
	if music_enabled and not player.playing:
		player.play()
