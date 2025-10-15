extends Control  # Cena da interface de opções

@onready var button_click = $buttonclick

func _ready() -> void:
	MusicController.play_music_for("menu")

func _on_back_pressed() -> void:
	button_click.play()
	await button_click.finished
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func _on_back_mouse_entered() -> void:
	$mouse_entered.play()
	await $mouse_entered.finished

func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			SettingsManager.set_resolution(Vector2i(1920, 1080))
			SaveManager.save_setting("resolution", "1920x1080")
		1:
			SettingsManager.set_resolution(Vector2i(1600, 900))
			SaveManager.save_setting("resolution", "1600x900")
		2:
			SettingsManager.set_resolution(Vector2i(1280, 720))
			SaveManager.save_setting("resolution", "1280x720")

func _on_clear_data_pressed() -> void:
	SaveManager.clear_high_scores()

func _on_clear_data_mouse_entered() -> void:
	$mouse_entered.play()
	await $mouse_entered.finished
