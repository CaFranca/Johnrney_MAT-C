extends HSlider  # Esse script é anexado a um controle deslizante (HSlider), usado para ajustar o volume de um bus de áudio

# Nome do bus de áudio (ex: "Master", "Music", "SFX"), configurável no editor
@export var bus_name: String

# Índice do bus, obtido com base no nome
var bus_index: int

func _ready() -> void:
	# Ao iniciar, obtém o índice do bus de áudio pelo nome fornecido
	bus_index = AudioServer.get_bus_index(bus_name)
	
	# Define o valor do slider com base no volume atual do bus (convertido de decibéis para escala linear de 0 a 1)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(value: float) -> void:
	# Quando o usuário mover o slider, ajusta o volume do bus correspondente
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
