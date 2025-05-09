extends Control

@onready var button_click=$buttonclick

#func _ready():
#	var player = MusicController.get_node("AudioStreamPlayer")
#	if not player.playing:
#		player.play()

func _on_start_pressed() -> void:
	button_click.play()
	get_tree().change_scene_to_file("res://scenes/Selection_mode_menu.tscn")

func _on_credits_pressed() -> void:
	pass # Substitua aqui

func _on_quit_pressed() -> void:
	get_tree().quit()
