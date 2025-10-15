extends HSlider

@export var bus_name: String  # Nome do bus de áudio que esse slider controla

var bus_index: int

func _ready() -> void:
	# Obtém o índice do bus de áudio baseado no nome
	bus_index = AudioServer.get_bus_index(bus_name)
	
	# Inicializa o valor do slider com o valor salvo no SaveManager para esse bus
	match bus_name:
		"Master":
			value = float(SaveManager.load_setting("master_volume", 1.0))
		"music":
			value = float(SaveManager.load_setting("music_volume", 1.0))
		"sfx":
			value = float(SaveManager.load_setting("sfx_volume", 1.0))
		_:
			# Se o bus_name não for reconhecido, pega o volume atual do AudioServer como fallback
			value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

	# Aplica o volume inicial no AudioServer e mudo se o volume estiver quase zero
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value <= 0.01)


func _on_value_changed(value: float) -> void:
	# Atualiza o volume e mute no AudioServer conforme o valor do slider
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value <= 0.01)

	# Atualiza o valor no SaveManager para salvar depois
	var setting_key = bus_name.to_lower() + "_volume"
	SaveManager.save_setting(setting_key, value)
