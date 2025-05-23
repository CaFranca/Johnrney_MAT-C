extends Node

# Caminho para o arquivo que armazenará as configurações do usuário
var settings_path := "user://user_settings.cfg"
# Caminho para o arquivo que armazenará o progresso do jogador
var progress_path := "user://user_progress.cfg"

# Dicionário que mantém as configurações do jogo na memória com valores padrão
var settings = {
	"music_on": true,          # Música ligada ou desligada
	"music_volume": 1.0,       # Volume da música (0.0 a 1.0)
	"sfx_volume": 1.0,         # Volume dos efeitos sonoros (SFX)
	"master_volume": 1.0,      # Volume geral do áudio
	"resolution": "1280x720"   # Resolução da tela
}

# Dicionário que mantém o progresso do jogador (pontuações e erros)
var progress = {
	"scores": {
		"add": 0,   # Pontuação para adição
		"sub": 0,   # Pontuação para subtração
		"mul": 0,   # Pontuação para multiplicação
		"div": 0,   # Pontuação para divisão
		"all": 0    # Pontuação geral
	},
	"errors": 0     # Contador de erros cometidos
}

func _ready():
	# Carrega as configurações salvas
	load_settings()
	# Aplica as configurações de áudio carregadas
	apply_audio_settings()
	# Carrega o progresso salvo
	load_progress()

	# Exibe no console os caminhos dos arquivos para debug
	print("============================================")
	print("🗂️ Caminho dos arquivos de configuração:")
	print("- Configurações:", ProjectSettings.globalize_path(settings_path))
	print("- Progresso:", ProjectSettings.globalize_path(progress_path))
	print("============================================")

	# Se existir um node do tipo Label chamado "path_label", atualiza seu texto com os caminhos
	var label = get_node_or_null("path_label")
	if label:
		label.text = "Settings path:\n" + ProjectSettings.globalize_path(settings_path) + "\n\n" + \
		"Progress path:\n" + ProjectSettings.globalize_path(progress_path)


# ============================================ #
# ================= SETTINGS ================= #
# ============================================ #

# Função para carregar as configurações do arquivo .cfg para o dicionário settings
func load_settings():
	var cfg = ConfigFile.new()
	var err = cfg.load(settings_path)  # Tenta carregar o arquivo
	if err == OK:
		# Se o arquivo existe, lê os valores e atualiza o dicionário
		settings.music_on = cfg.get_value("audio", "music_on", true)
		settings.music_volume = cfg.get_value("audio", "music_volume", 1.0)
		settings.sfx_volume = cfg.get_value("audio", "sfx_volume", 1.0)
		settings.master_volume = cfg.get_value("audio", "master_volume", 1.0)
		settings.resolution = cfg.get_value("display", "resolution", "1280x720")
		print("✅ Configurações carregadas com sucesso.")
	else:
		# Se o arquivo não existir, cria um novo com valores padrão
		print("⚠️ Arquivo de configurações não encontrado. Criando novo com valores padrão.")
		save_settings()

# Função para salvar as configurações do dicionário settings no arquivo .cfg
func save_settings():
	var cfg = ConfigFile.new()
	cfg.set_value("audio", "music_on", settings.music_on)
	cfg.set_value("audio", "music_volume", settings.music_volume)
	cfg.set_value("audio", "sfx_volume", settings.sfx_volume)         # Salva volume dos efeitos sonoros
	cfg.set_value("audio", "master_volume", settings.master_volume)   # Salva volume master
	cfg.set_value("display", "resolution", settings.resolution)
	
	var err = cfg.save(settings_path)  # Tenta salvar o arquivo
	if err == OK:
		print("💾 Configurações salvas com sucesso em:", ProjectSettings.globalize_path(settings_path))
	else:
		print("❌ Erro ao salvar configurações:", err)


# ============================================ #
# ================= PROGRESS ================= #
# ============================================ #

# Função para carregar o progresso salvo do jogador
func load_progress():
	var cfg = ConfigFile.new()
	var err = cfg.load(progress_path)
	if err == OK:
		# Se o arquivo existir, carrega as pontuações e erros
		for mode in progress.scores.keys():
			progress.scores[mode] = int(cfg.get_value("scores", mode, 0))
		progress.errors = int(cfg.get_value("game", "errors", 0))
		print("✅ Progresso carregado com sucesso.")
	else:
		# Se não existir, cria um novo arquivo com progresso zerado
		print("⚠️ Arquivo de progresso não encontrado. Criando novo com valores padrão.")
		save_progress()

# Função para salvar o progresso atual do jogador no arquivo
func save_progress():
	var cfg = ConfigFile.new()
	for mode in progress.scores.keys():
		cfg.set_value("scores", mode, progress.scores[mode])
	cfg.set_value("game", "errors", progress.errors)
	var err = cfg.save(progress_path)
	if err == OK:
		print("💾 Progresso salvo com sucesso em:", ProjectSettings.globalize_path(progress_path))
	else:
		print("❌ Erro ao salvar progresso:", err)


# ============================================ #
# ========== MÉTODOS DE ATUALIZAÇÃO ========== #
# ============================================ #

# Adiciona uma pontuação para um modo específico e salva o progresso
func add_score(mode: String, amount: int = 1):
	if progress.scores.has(mode):
		progress.scores[mode] += amount
		print("➕ Pontuação adicionada em", mode, "Novo valor:", progress.scores[mode])
		save_progress()  # Salva o progresso atualizado
	else:
		print("❌ Modo de pontuação inválido:", mode)

# Adiciona um erro ao contador e salva o progresso
func add_error():
	progress.errors += 1
	print("❌ Erro adicionado. Total de erros:", progress.errors)
	save_progress()


# ============================================ #
# ============ APLICAR CONFIGURAÇÕES ========= #
# ============================================ #

# Aplica os volumes configurados às respectivas buses de áudio do Godot
func apply_audio_settings():
	# Ajusta volume e mute da bus "Master"
	var master_index = AudioServer.get_bus_index("Master")
	if master_index != -1:
		AudioServer.set_bus_volume_db(master_index, linear_to_db(settings.master_volume))
		AudioServer.set_bus_mute(master_index, settings.master_volume <= 0.01)
		print("🔊 Volume Master aplicado:", settings.master_volume)
	else:
		print("❌ Bus 'Master' não encontrado!")

	# Ajusta volume e mute da bus "music"
	var music_index = AudioServer.get_bus_index("music")
	if music_index != -1:
		AudioServer.set_bus_volume_db(music_index, linear_to_db(settings.music_volume))
		AudioServer.set_bus_mute(music_index, settings.music_volume <= 0.01)
		print("🎶 Volume music aplicado:", settings.music_volume)
	else:
		print("❌ Bus 'music' não encontrado!")

	# Ajusta volume e mute da bus "sfx"
	var sfx_index = AudioServer.get_bus_index("sfx")
	if sfx_index != -1:
		AudioServer.set_bus_volume_db(sfx_index, linear_to_db(settings.sfx_volume))
		AudioServer.set_bus_mute(sfx_index, settings.sfx_volume <= 0.01)
		print("🔊 Volume sfx aplicado:", settings.sfx_volume)
	else:
		print("❌ Bus 'sfx' não encontrado!")
