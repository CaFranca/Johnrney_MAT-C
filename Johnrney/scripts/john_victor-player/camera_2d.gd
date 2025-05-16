extends Camera2D  # Este script estende a classe Camera2D, controlando uma câmera 2D

# Definindo os limites que a câmera pode se mover (em pixels)
var left_limit = 0       # Limite esquerdo da câmera
var right_limit = 2000   # Limite direito da câmera
var top_limit = 0        # Limite superior da câmera
var bottom_limit = 1200  # Limite inferior da câmera

func _process(delta):
	# Executado a cada frame. "delta" é o tempo decorrido desde o último frame

	# Obtém a referência ao nó do jogador (substitua o caminho se necessário)
	var player = get_node("/root/Player")  # Isso espera que o Player esteja como um nó na raiz da cena

	# Define a posição da câmera para seguir a posição do jogador
	position = player.position

	# Limita a posição da câmera para que ela não ultrapasse os limites definidos
	position.x = clamp(position.x, left_limit, right_limit)
	position.y = clamp(position.y, top_limit, bottom_limit)
