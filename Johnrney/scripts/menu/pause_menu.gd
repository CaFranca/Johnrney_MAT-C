extends Control

# Referência ao som de clique do botão (nó AudioStreamPlayer)
@onready var button_click = $buttonclick

# Variável para armazenar a referência da cena principal do gameplay
var gameplay_scene  

# Define a referência para a cena do gameplay, usada para controlar pausa, reinício, etc.
func set_gameplay(scene):
	gameplay_scene = scene

# Função chamada quando o botão "Continuar" (resume) é pressionado no menu de pausa
func _on_resume_pressed() -> void:
	button_click.play()  # Toca som de clique
	await button_click.finished  # Aguarda o som terminar antes de continuar
	
	# Se a cena de gameplay estiver definida e possuir o método pauseMenu, chama ele para alternar pausa
	if gameplay_scene and gameplay_scene.has_method("pauseMenu"):
		gameplay_scene.pauseMenu()

# Função chamada quando o botão "Sair" (quit) é pressionado no menu de pausa
func _on_quit_pressed() -> void:
	# Garante que o jogo volte ao tempo normal e que o estado pausado seja desativado
	Engine.time_scale = 1
	get_tree().paused = false
	
	button_click.play()  # Toca som de clique
	await button_click.finished  # Aguarda o som terminar
	
	# Troca a cena para o menu de seleção de modo do jogo
	get_tree().change_scene_to_file("res://scenes/menu/Selection_mode_menu.tscn")

# Função chamada quando o botão "Reiniciar" (restart) é pressionado no menu de pausa
func _on_restart_pressed() -> void:
	button_click.play()  # Toca som de clique
	await button_click.finished  # Aguarda o som terminar
	
	# Garante que o tempo do jogo esteja normal e o estado pausado desativado
	Engine.time_scale = 1
	get_tree().paused = false

	# Se a cena de gameplay estiver definida e possuir o método restart_game, chama para reiniciar o jogo
	if gameplay_scene and gameplay_scene.has_method("restart_game"):
		gameplay_scene.restart_game()


func _on_forfeit_pressed() -> void:
	button_click.play()
	await button_click.finished
	# Garantir que o jogo sai do estado de pausa
	Engine.time_scale = 1
	get_tree().paused = false

	if gameplay_scene and gameplay_scene.player_controller:
		gameplay_scene.player_controller.forfeit_game()
	else:
		push_error("Não foi possível acessar player_controller para forfeit_game()")

	
