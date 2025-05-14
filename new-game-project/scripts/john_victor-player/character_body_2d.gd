extends CharacterBody2D  # Este script controla um personagem 2D que se move e pula

# Constantes para controlar o movimento
const SPEED = 200.0        # Velocidade de movimento no eixo X e Y
const JUMP_HEIGHT = 50     # Altura máxima que o pulo pode alcançar
const JUMP_SPEED = 150.0   # Velocidade com que o personagem sobe e desce no pulo

# Variável que aponta para o nó de animação
@onready var animation := $AnimatedSprite2D

# Variáveis que controlam o estado do pulo
var is_jumping := false           # Informa se o personagem está pulando
var jump_start_y := 0             # Armazena a posição inicial do pulo (Y)
var jump_peak_reached := false   # Define se o topo do pulo foi alcançado
var jump_velocity := 0           # Velocidade vertical controlada manualmente para o pulo

func _physics_process(delta: float) -> void:
	# Entrada de movimento horizontal: usa as setas ou WASD
	var direction_x := Input.get_axis("ui_left", "ui_right")
	if direction_x == 0:  # Se as setas não forem pressionadas, verifica A e D
		direction_x = -1 if Input.is_key_pressed(KEY_A) else 1 if Input.is_key_pressed(KEY_D) else 0

	# Entrada de movimento vertical: usa as setas ou WASD
	var direction_y := Input.get_axis("ui_up", "ui_down")
	if direction_y == 0:  # Se as setas não forem pressionadas, verifica W e S
		direction_y = -1 if Input.is_key_pressed(KEY_W) else 1 if Input.is_key_pressed(KEY_S) else 0

	var jump := Input.is_action_just_pressed("ui_accept")  # Detecta se a tecla de pulo foi pressionada (por padrão, Enter ou espaço)

	# Início do pulo
	if jump and not is_jumping:
		is_jumping = true
		jump_start_y = position.y              # Armazena a altura inicial
		jump_peak_reached = false              # Ainda não atingiu o topo
		jump_velocity = -JUMP_SPEED            # Começa subindo
		animation.play("Jump")                 # Toca a animação de pulo

	# Controle do pulo (subida e descida)
	if is_jumping:
		position.y += jump_velocity * delta    # Aplica o movimento vertical manual
		if not jump_peak_reached:
			# Verifica se chegou ao topo do pulo ou colidiu com o teto
			if position.y <= jump_start_y - JUMP_HEIGHT or is_on_ceiling():
				jump_peak_reached = true       # Atingiu o ponto máximo
				jump_velocity = JUMP_SPEED     # Começa a descer
		else:
			# Verifica se voltou ao solo ou colidiu com o chão
			if position.y >= jump_start_y or is_on_floor():
				position.y = jump_start_y      # Corrige a posição vertical
				is_jumping = false             # Termina o pulo
				jump_velocity = 0              # Zera a velocidade vertical

	# Movimento horizontal
	if direction_x != 0:
		velocity.x = direction_x * SPEED
		$AnimatedSprite2D.flip_h = direction_x < 0  # Vira o sprite para a direção correta
	else:
		velocity.x = 0

	# Movimento vertical (só funciona se não estiver pulando)
	if not is_jumping:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = 0  # Impede que o direcional interfira durante o pulo

	# Controle das animações com base no movimento
	if not is_jumping:
		if direction_x != 0:
			animation.play("Run")            # Correndo na horizontal
		elif direction_y < 0:
			animation.play("Run_Up")         # Correndo para cima
		elif direction_y > 0:
			animation.play("Run_Down")       # Correndo para baixo
		else:
			animation.play("Idle")           # Parado

	move_and_slide()  # Aplica o movimento com colisão integrada
