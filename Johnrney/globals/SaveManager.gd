extends Node

var db_path := "user://game_data.db"
var db

func _ready():
	db = SQLite.new()
	db.path = db_path
	
	if not db.open_db():
		printerr("Erro: Não foi possível abrir o banco de dados em ", db_path)
		return
		
	print("Banco de dados aberto com sucesso em: ", ProjectSettings.globalize_path(db_path))
	
	_initialize_database()
	apply_audio_settings()

func _initialize_database():
	db.query("CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value TEXT);")
	db.query("CREATE TABLE IF NOT EXISTS progress_summary (mode TEXT PRIMARY KEY, total_scores INTEGER DEFAULT 0, total_errors INTEGER DEFAULT 0);")
	db.query("CREATE TABLE IF NOT EXISTS high_scores (id INTEGER PRIMARY KEY AUTOINCREMENT, score INTEGER, errors INTEGER, mode TEXT, timestamp TEXT);")
	
	var modes = ["add", "sub", "mul", "div", "all"]
	for mode in modes:
		# bindings são como uma peça que completa o quebra-cabeça da query --> values (?) recebe o modo vindo de [mode]
		db.query_with_bindings("INSERT OR IGNORE INTO progress_summary (mode) VALUES (?);", [mode])

# ============================================ #
# =============== CONFIGURAÇÕES ============== #
# ============================================ #

func save_setting(key: String, value):
	db.query_with_bindings("INSERT OR REPLACE INTO settings (key, value) VALUES (?, ?);", [key, str(value)])

func load_setting(key: String, default_value):
	var table = "settings"
	var where_clause = "key = '%s'" % [key]
	var columns = ["value"]
	var result = db.select_rows(table, where_clause, columns)
	# ordem estrutural do select_rows: 1- tabela onde pesquisar; 2- sentença where; 3- o que será retornado desse select
	
	if result.size() > 0:
		return result[0]["value"]
	return default_value

# ============================================ #
# ================= PROGRESS ================= #
# ============================================ #

func add_score(mode: String, amount: int = 1):
	db.query_with_bindings("UPDATE progress_summary SET total_scores = total_scores + ? WHERE mode = ?;", [amount, mode])
	print("Pontuação adicionada em ", mode)

func add_error(mode: String, amount: int = 1):
	db.query_with_bindings("UPDATE progress_summary SET total_errors = total_errors + ? WHERE mode = ?;", [amount, mode])
	print("Erro adicionado no modo ", mode)

func add_high_score(score: int, errors: int, mode: String):
	if score <= 0: return
	var date = Time.get_datetime_dict_from_system(false)
	var formatted_date = "%04d-%02d-%02d %02d:%02d:%02d" % [date.year, date.month, date.day, date.hour, date.minute, date.second]
	db.query_with_bindings("INSERT INTO high_scores (score, errors, mode, timestamp) VALUES (?, ?, ?, ?);", [score, errors, mode, formatted_date])
	print("Novo high score registrado.")
	_trim_high_scores(mode)

func _trim_high_scores(mode: String):
	var table = "high_scores"
	var where_clause = "mode = '%s' ORDER BY score DESC, errors ASC, timestamp DESC LIMIT 1 OFFSET 5" % [mode]
	var columns = ["id"]
	var result = db.select_rows(table, where_clause, columns)
	
	if result.size() > 0:
		var delete_query = "DELETE FROM high_scores WHERE mode = ? AND id IN (SELECT id FROM high_scores WHERE mode = ? ORDER BY score DESC, errors ASC, timestamp DESC OFFSET 5);"
		db.query_with_bindings(delete_query, [mode, mode])
		print("Limpeza de scores baixos para o modo '", mode, "' concluída.")

func get_top_scores_for_mode(mode: String) -> Array:
	var table = "high_scores"
	var where_clause = "mode = '%s' ORDER BY score DESC, errors ASC, timestamp DESC LIMIT 5" % [mode]
	var columns = ["*"] # pega todas as colunas
	var result = db.select_rows(table, where_clause, columns)

	print("🏅 Top scores para o modo: ", mode)
	for i in range(result.size()):
		var r = result[i]
		print("%dº Lugar - Score: %d, Erros: %d, Data: %s" % [i+1, r["score"], r["errors"], r["timestamp"]])
		
	return result

func clear_high_scores():
	db.query("DELETE FROM high_scores;")
	db.query("UPDATE progress_summary SET total_scores = 0, total_errors = 0;")
	print("Todos os RECORDES, ACERTOS e ERROS foram apagados.")
	

func apply_audio_settings():
	var master_volume = float(load_setting("master_volume", 1.0))
	var music_volume = float(load_setting("music_volume", 1.0))
	var sfx_volume = float(load_setting("sfx_volume", 1.0))
	
	var master_index = AudioServer.get_bus_index("Master")
	if master_index != -1: AudioServer.set_bus_volume_db(master_index, linear_to_db(master_volume))

	var music_index = AudioServer.get_bus_index("music")
	if music_index != -1: AudioServer.set_bus_volume_db(music_index, linear_to_db(music_volume))

	var sfx_index = AudioServer.get_bus_index("sfx")
	if sfx_index != -1: AudioServer.set_bus_volume_db(sfx_index, linear_to_db(sfx_volume))

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST and db:
		db.close_db()
		print("Banco de dados fechado.")

func delete_database_file():
	if db: 
		db.close_db()
	
	var dir = DirAccess.open("user://")
	
	if dir.file_exists("game_data.db"):
		var err = dir.remove("game_data.db")
		if err == OK: 
			get_tree().reload_current_scene()
