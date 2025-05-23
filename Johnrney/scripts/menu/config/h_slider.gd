extends HSlider  # Esse script é anexado a um controle deslizante (HSlider), usado para ajustar o volume de um bus de áudio

# Nome do bus de áudio (ex: "Master", "Music", "SFX")
# Esse valor deve ser definido no Inspetor do Godot para que o slider controle o bus correto
@export var bus_name: String

# Índice numérico do bus, usado internamente pela AudioServer para acessar o bus mais rapidamente
var bus_index: int

func _ready() -> void:
	# Ao iniciar, obtém o índice do bus de áudio pelo nome fornecido
	# Caso o nome não exista, retorna -1 (convém validar se quiser evitar erros)
	bus_index = AudioServer.get_bus_index(bus_name)
	
	# Define o valor do slider de acordo com o volume atual do bus
	# Converte de decibéis (usado internamente pelo AudioServer) para escala linear (0.0 a 1.0), que o slider entende
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(value: float) -> void:
	# Este método deve estar conectado ao sinal 'value_changed' do próprio HSlider
	# Quando o usuário mover o slider, convertemos o valor linear (0.0 a 1.0) de volta para decibéis
	# e aplicamos esse volume no bus de áudio correspondente
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
