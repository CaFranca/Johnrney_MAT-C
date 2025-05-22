extends Control

@onready var button_click = $buttonclick
@onready var pause_menu = $"."



func resume():
	get_tree().paused = false
	Engine.time_scale = 1
	
func pause():
	get_tree().paused = true
	Engine.time_scale = 0

func testEsc():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause_menu.show()
		pause()
	else:
		pause_menu.hide()
		resume()

func _on_resume_pressed() -> void:
	print("sla")

func _on_quit_pressed() -> void:
	button_click.play()
	await button_click.finished
	print("Clicado para voltar")
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
	
func _process(delta: float):
	testEsc()
