extends Node

# Sinal emitido quando o jogo acaba (quando o número máximo de erros é atingido)
signal game_over

# Número máximo de erros permitidos antes do game over
var max_errors: int = 5
# Contador atual de erros cometidos pelo jogador
var current_errors: int = 0
# Modo desenvolvedor que ignora falhas para facilitar testes/debug
var developer_mode := false

# Referência ao container que guarda os corações na UI (barra de vida)
@onready var hearts_container = $healthbar/HBoxContainer
@onready var current_combo = $mode_gameplay/current_combo

func _ready():
	# Inicializa a interface visual dos corações ao iniciar o nó
	update_hearts()

# Registra uma falha do jogador
func register_failure():
	# Se modo desenvolvedor estiver ativado, ignora o registro da falha
	if developer_mode:
		return

	# Incrementa o contador de erros
	current_errors += 1
	# Atualiza a barra de corações para refletir o novo número de erros
	update_hearts()

	# Se o número de erros atingir o máximo, emite o sinal de game over
	if current_errors >= max_errors:
		emit_signal("game_over")

# Reseta o contador de erros e restaura a UI dos corações
func reset():
	# Zera a contagem de erros
	current_errors = 0
	# Deixa todos os corações visíveis na interface
	for i in range(max_errors):
		var heart = hearts_container.get_child(i)
		if heart is AnimatedSprite2D:
			heart.visible = true  # Torna o coração visível novamente
	# Atualiza a animação dos corações após o reset
	update_hearts()

# Função chamada quando a animação de um coração termina
func _on_heart_animation_finished(heart: AnimatedSprite2D):
	# Se a animação que terminou for a "empty" (coração vazio), oculta o coração
	if heart.animation == "empty":
		heart.visible = false

# Atualiza a exibição dos corações de acordo com o número atual de erros
func update_hearts():
	# Verifica se o container dos corações ainda existe (para evitar erros)
	if not is_instance_valid(hearts_container):
		return

	var children_count = hearts_container.get_child_count()

	# Para cada coração, decide se ele deve estar cheio (idle) ou vazio (empty)
	for i in range(max_errors):
		if i >= children_count:
			continue  # Caso tenha menos corações no container do que o max_errors

		var heart = hearts_container.get_child(i)
		if heart is AnimatedSprite2D:
			if i < max_errors - current_errors:
				# Corações restantes ficam visíveis e com animação "idle" (cheio)
				heart.visible = true
				heart.play("idle")
			else:
				# Se o coração representa um erro, toca a animação "empty" e depois oculta
				if heart.visible:
					heart.play("empty")
					# Aguarda 0.5 segundos para a animação tocar antes de ocultar o coração
					await get_tree().create_timer(0.5).timeout
					_on_heart_animation_finished(heart)

# Captura evento de teclado para ativar ou desativar o modo desenvolvedor com F12
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_F12:
		# Alterna o estado do modo desenvolvedor
		developer_mode = !developer_mode
		
		if developer_mode:
			print("Developer Mode ATIVADO")
		else:
			print("Developer Mode DESATIVADO")
			
# Função para desistir da partida instantaneamente
func forfeit_game():
	# Avisa que é uma falha fatal proposital
	print("Jogador desistiu da partida!")
	# Garante que zera a vida
	current_errors = max_errors
	# Atualiza os corações (animações e visuais)
	update_hearts()
	# Emite o sinal de game over
	emit_signal("game_over")
	
func addHeart_sequencia(current_combo):
	if current_combo > 5:
		if current_combo > 0:
			current_errors -=1
			print("Coração recuperado por combo! Erros agora:", current_errors)
			update_hearts()
		return true
	return false
