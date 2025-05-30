extends Node

var resolution : Vector2i = Vector2i(1280, 720)
var is_fullscreen : bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		toggle_fullscreen()

func set_resolution(size: Vector2i) -> void:
	DisplayServer.window_set_size(size)
	resolution = size

func toggle_fullscreen() -> void:
	is_fullscreen = not is_fullscreen
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		# Restaura a resolução da janela quando sai do fullscreen
		set_resolution(resolution)

func apply_fullscreen(force_state: bool) -> void:
	is_fullscreen = force_state
	if force_state:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		set_resolution(resolution)
