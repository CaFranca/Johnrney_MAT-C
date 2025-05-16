extends Node

signal game_over  # Sinal emitido quando o jogo acaba (número máximo de erros atingido)

var max_errors: int = 5  # Número máximo de erros permitidos
var current_errors: int = 0  # Contador atual de erros cometidos
var developer_mode := false  # Modo desenvolvedor que ignora falhas

@onready var hearts_container = $healthbar/HBoxContainer  # Container que guarda os corações (UI)

func _ready():
	# Inicializa os corações na interface
	update_hearts()

func register_failure():
	# Se o modo desenvolvedor estiver ativo, ignora a falha
	if developer_mode:
		return

	# Incrementa a contagem de erros
	current_errors += 1
	# Atualiza a interface com o estado dos corações
	update_hearts()

	# Se atingir o número máximo de erros, emite o sinal de game over
	if current_errors >= max_errors:
		emit_signal("game_over")

func reset():
	# Reseta o número de erros e deixa todos os corações visíveis (reset UI)
	current_errors = 0
	for i in range(max_errors):
		var heart = hearts_container.get_child(i)
		if heart is AnimatedSprite2D:
			heart.visible = true  # Reaparece ao resetar
	update_hearts()

# Função chamada após a animação do coração terminar
func _on_heart_animation_finished(heart: AnimatedSprite2D):
	# Se a animação que terminou for a 'empty', oculta o coração
	if heart.animation == "empty":
		heart.visible = false

func update_hearts():
	# Verifica se o container dos corações ainda é válido
	if not is_instance_valid(hearts_container):
		return

	var children_count = hearts_container.get_child_count()

	# Atualiza cada coração de acordo com o número de erros
	for i in range(max_errors):
		if i >= children_count:
			continue

		var heart = hearts_container.get_child(i)
		if heart is AnimatedSprite2D:
			if i < max_errors - current_errors:
				# Corações restantes ficam visíveis e com animação "idle"
				heart.visible = true
				heart.play("idle")
			else:
				# Apenas toca animação "empty" se o coração estiver visível
				if heart.visible:
					heart.play("empty")
					# Aguarda a animação tocar por 0.5 segundos antes de ocultar
					await get_tree().create_timer(0.5).timeout
					_on_heart_animation_finished(heart)

# Captura evento de teclado para ativar/desativar o modo desenvolvedor
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_F12:
		developer_mode = !developer_mode
		if developer_mode:
			print("Developer Mode ATIVADO")
		else:
			print("Developer Mode DESATIVADO")
