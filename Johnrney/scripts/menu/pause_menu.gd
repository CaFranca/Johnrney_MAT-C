extends Control

@onready var button_click = $buttonclick
var gameplay_scene  # Referência para a gameplay

func set_gameplay(scene):
	gameplay_scene = scene


func _on_resume_pressed() -> void:
	button_click.play()
	await button_click.finished
	
	if gameplay_scene and gameplay_scene.has_method("pauseMenu"):
		gameplay_scene.pauseMenu()


func _on_quit_pressed() -> void:
	Engine.time_scale = 1
	get_tree().paused = false
	
	button_click.play()
	await button_click.finished
	
	get_tree().change_scene_to_file("res://scenes/menu/Selection_mode_menu.tscn")


func _on_restart_pressed() -> void:
	button_click.play()
	await button_click.finished
	
	Engine.time_scale = 1
	get_tree().paused = false

	if gameplay_scene and gameplay_scene.has_method("restart_game"):
		gameplay_scene.restart_game()
