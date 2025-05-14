extends Control

@onready var button_click=$buttonclick

func _ready() -> void:
	#MusicController.toggle_music(true)
	pass


func _on_back_pressed() -> void:
	button_click.play()
	await button_click.finished
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func _on_back_mouse_entered() -> void:
	$mouse_entered.play()
	await $mouse_entered.finished

#func _on_musica_toggled(toggled_on: bool) -> void:
#	MusicController.toggle_music(toggled_on)


func _on_musics_toggled(toggled_on: bool) -> void:
	MusicController.toggle_music(toggled_on)


func _on_music_volume_value_changed(value) -> void:
	MusicController.slide_bar(value)


func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))
