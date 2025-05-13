extends Control

@onready var button_click=$buttonclick


func _on_start_pressed() -> void:
	print("Botão start clicado")
	button_click.play()
	await button_click.finished
	get_tree().change_scene_to_file("res://scenes/Selection_mode_menu.tscn")

func _on_credits_pressed() -> void:
	button_click.play()
	await button_click.finished

func _on_quit_pressed() -> void:
	button_click.play()
	await button_click.finished
	get_tree().quit()


func _on_start_mouse_entered() -> void:
	$mouse_entered.play()
	await $mouse_entered.finished


func _on_credits_mouse_entered() -> void:
	$mouse_entered.play()
	await $mouse_entered.finished


func _on_quit_mouse_entered() -> void:
	$mouse_entered.play()
	await $mouse_entered.finished


func _on_cavibezz_pressed() -> void:
	button_click.play()
	await button_click.finished
	OS.shell_open("https://www.youtube.com/@CaVibezz")


func _on_cavibezz_mouse_entered() -> void:
	$mouse_entered.play()
	await $mouse_entered.finished


func _on_musica_toggled(toggled_on: bool) -> void:
	MusicController.toggle_music(toggled_on)
