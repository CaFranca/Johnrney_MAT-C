extends Node

# Enumeração dos passos do tutorial
enum State {
	BEM_VINDO,      # Mostra o texto inicial
	PRIMEIRA_CONTA, # Spawna "2+2"
	ESPERA_RESPOSTA_1, # Aguarda o jogador acertar
	FEEDBACK_1,     # Diz "Correto!"
	SEGUNDA_CONTA,  # Spawna "5-1"
	ESPERA_RESPOSTA_2, # Aguarda o jogador acertar
	AVISO, 
	AVISO_2,
	AVISO_3,
	AVISO_4,
	AVISO_5,
	FINALIZAR       # Salva e sai
}

var current_state = State.BEM_VINDO
var resposta_esperada = ""

# --- CONECTE SEUS NÓS AQUI ---
# Arraste os nós do painel "Cena" para o Inspetor para conectá-los
@export var spawner: Node
@export var label: Label 
@export var botao: Button
@export var input: LineEdit
@export var spawn_timer: Timer
# ---------------------------------

func _ready():
	# Conectar os sinais que vamos usar
	botao.pressed.connect(_on_botao_continuar_pressed)
	input.text_submitted.connect(_on_input_text_submitted)
	
	# Checagens de segurança
	if not spawner or not label or not botao or not input:
		printerr("TUTORIAL ERRO: Um ou mais nós não foram conectados no Inspetor!")
		return
	
	# Diz ao Spawner para PARAR o jogo normal e entrar em modo tutorial
	spawner.set_tutorial_mode(true) 
	
	# Inicia a máquina de estados
	_mudar_estado(State.BEM_VINDO)
	

func _mudar_estado(novo_estado):
	current_state = novo_estado
	
	match current_state:
		State.BEM_VINDO:
			label.text = "Bem-vindo ao Johnrney! \nVamos aprender a jogar."
			botao.text = "Começar"
			botao.show()
			input.hide()
			
		State.PRIMEIRA_CONTA:
			label.text = "Uma conta vai cair. \nDigite a resposta e pressione Enter!"
			botao.hide()
			input.show()
			input.grab_focus() # Foca o cursor no input
			
			# Chama a nova função no spawner
			# (Pergunta, Resposta, Posição X, Dificuldade)
			spawner.spawn_tutorial_equation("2 + 2 = ?", 4, 300, "facil", true)
			
			resposta_esperada = "4"
			_mudar_estado(State.ESPERA_RESPOSTA_1)
			
		State.ESPERA_RESPOSTA_1:
			# Estado de espera. A ação acontece no sinal _on_input_text_submitted
			pass 
			
		State.FEEDBACK_1:
			label.text = "Perfeito! Você destruiu a conta. \nVamos mais uma vez."
			botao.text = "Continuar"
			botao.show()
			input.hide()

		State.SEGUNDA_CONTA:
			label.text = "Vamos ver se você aprendeu.\nMais uma!"
			botao.hide()
			input.show()
			input.grab_focus()
			
			spawner.spawn_tutorial_equation("8 - 5 = ?", 3, 250, "facil", true)
			resposta_esperada = "3"
			_mudar_estado(State.ESPERA_RESPOSTA_2)

		State.ESPERA_RESPOSTA_2:
			pass

		State.AVISO:
			label.text = "O Johnrney conta com 5 modos \ndiferentes."
			botao.show()
			botao.text = "Continuar"
			input.hide()
			
		State.AVISO_2:
			label.text = "São eles: Adição, Subtração, \nMultiplicação, Divisão e Todos."
			botao.text = "Continuar"
			
		State.AVISO_3:
			label.text = "Você pode selecionar a dificuldade: \nNormal ou Difícil."
			botao.text = "Continuar"
			
		State.AVISO_4:
			label.text = "Se você perder um coração, \nainda pode recuperá-lo!"
			botao.text = "Continuar"
			
		State.AVISO_5:
			label.text = "Acerte contas em sequência, \naumentando de 5 em 5!"
			botao.text = "Continuar"
		
		State.FINALIZAR:
			label.text = "Você pegou o jeito! \nDivirta-se e aprenda!"
			botao.hide()
			
			
			# Salva o progresso
			SaveManager.save_tutorial_complete()
			
			# Espera 2 segundos para o jogador ler e vai para o menu principal
			await get_tree().create_timer(2.0).timeout
			get_tree().change_scene_to_file("res://cenas/main_menu.tscn")

# --- Funções de Sinais ---

func _on_botao_continuar_pressed():
	if current_state == State.BEM_VINDO:
		_mudar_estado(State.PRIMEIRA_CONTA)
		
	elif current_state == State.FEEDBACK_1:
		_mudar_estado(State.SEGUNDA_CONTA)
		
	elif current_state == State.AVISO:
		_mudar_estado(State.AVISO_2)
		
	elif current_state == State.AVISO_2:
		_mudar_estado(State.AVISO_3)
		
	elif current_state == State.AVISO_3:
		_mudar_estado(State.AVISO_4)
		
	elif current_state == State.AVISO_4:
		_mudar_estado(State.AVISO_5)
		
	elif current_state == State.AVISO_5:
		_mudar_estado(State.FINALIZAR)
	

func _on_input_text_submitted(texto_digitado):
	# Normaliza o texto (remove espaços)
	var texto_limpo = texto_digitado.strip_edges()
	
	if texto_limpo == resposta_esperada:
		# Se acertou...
		
		# --- SUBSTITUA ESTA LINHA ---
		# spawner.destruir_conta_atual()  <-- APAGUE ISSO
		
		# --- POR ESTA LINHA ---
		spawner.check_answer() # <-- ADICIONE ISSO
		
		# input.clear()  <-- PODE APAGAR. check_answer() já faz isso.
		
		# Avança o estado
		if current_state == State.ESPERA_RESPOSTA_1:
			_mudar_estado(State.FEEDBACK_1)
			
		elif current_state == State.ESPERA_RESPOSTA_2:
			_mudar_estado(State.AVISO)
	else:
		# Se errou
		label.text = "Resposta errada. Vou te ajudar! \nA resposta era %s." % resposta_esperada
		# Limpa o campo de input para o jogador tentar de novo
		input.clear()
