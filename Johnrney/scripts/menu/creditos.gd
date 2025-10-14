extends Control

# Pré-carrega a cena principal do modo de gameplay (jogo matemático)
var gameplay_scene = preload("res://scenes/gameplay/mode_gameplay.tscn")

# Referência ao efeito sonoro do clique do botão
@onready var button_click = $buttonclick

# Dicionário que associa cada modo ao seu respectivo Label na interface
@onready var score_labels = {
	"add": $MarginContainer/HBoxContainer/VBoxContainer/sum_rank,
	"sub": $MarginContainer/HBoxContainer/VBoxContainer/minus_rank,
	"mul": $MarginContainer/HBoxContainer/VBoxContainer/times_rank,
	"div": $MarginContainer/HBoxContainer/VBoxContainer/div_rank,
	"all": $MarginContainer/HBoxContainer/VBoxContainer/all_rank
}

# Executado quando a cena é carregada
func _ready():
	# Garante que a árvore de nós esteja totalmente processada
	await get_tree().process_frame

func _play_button_click():
	button_click.play()
	return button_click.finished

# Função do botão de voltar ao menu principal
func _on_back_pressed() -> void:
	await _play_button_click()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
