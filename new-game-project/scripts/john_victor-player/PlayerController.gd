extends Node  # Script que estende um nó básico

signal game_over  # Define um sinal que será emitido quando o jogo acabar

var max_errors: int = 5  # Número máximo de falhas permitidas antes do game over
var current_errors: int = 0  # Contador atual de falhas do jogador

var developer_mode := false  # Flag que indica se o modo desenvolvedor (imortalidade) está ativado

func register_failure():
	# Se o modo desenvolvedor estiver ativo, ignora a falha e apenas imprime no console
	if developer_mode:
		print("Developer Mode ativo: falha ignorada.")
		return  # Sai da função, não incrementa falhas

	# Incrementa o número de falhas
	current_errors += 1
	print("Falhas: ", current_errors,"/", max_errors)

	# Se o número de falhas atingir o máximo, emite o sinal de game over
	if current_errors >= max_errors:
		emit_signal("game_over")

func reset():
	# Reseta o contador de falhas para zero, por exemplo, quando iniciar um novo jogo
	current_errors = 0

# Função chamada automaticamente pelo Godot para processar eventos de entrada (teclado, mouse, etc)
func _input(event):
	# Verifica se o evento é uma tecla sendo pressionada e se é a tecla F12
	if event is InputEventKey and event.pressed and event.keycode == KEY_F12:
		# Alterna o estado do modo desenvolvedor (true <-> false)
		developer_mode = !developer_mode
		# Imprime no console se o modo foi ativado ou desativado
		if developer_mode:
			print("Developer Mode ATIVADO")
		else:
			print("Developer Mode DESATIVADO")
