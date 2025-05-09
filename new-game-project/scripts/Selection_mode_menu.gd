extends Control

var gameplay_scene = preload("res://scenes/mode_gameplay.tscn")
@onready var button_click=$buttonclick

func _ready():
	var player = MusicController.get_node("AudioStreamPlayer") #pegando a musica, esta em autoload

	if not player.playing:
		player.play() #tocando a musica
func _start_game_with_mode(mode: String) -> void:
	button_click.play()
	await button_click.finished

	var scene_instance = gameplay_scene.instantiate()
	scene_instance.set_mode(mode)
	get_tree().root.add_child(scene_instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene_instance

func _on_sum_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("add")

func _on_minus_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("sub")

func _on_times_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("mul")

func _on_div_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("div")

func _on_all_pressed() -> void:
	button_click.play()
	await button_click.finished
	_start_game_with_mode("all")

func _on_back_pressed() -> void:
	button_click.play()
	await button_click.finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
