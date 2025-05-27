extends Control

signal hint_closed

@onready var button_click = $buttonclick
@onready var title_label = $CanvasLayer/Label
@onready var hint_text = $CanvasLayer/RichTextLabel

var mode := ""
var gameplay_scene

var add_hints = [
	"Soma é juntar quantidades. Ex.: 2 + 3 = 5.",
	"Quando você soma, o resultado sempre cresce.",
	"Use os dedos para somar pequenas quantidades.",
	"2 + 0 continua sendo 2. Somar zero não muda o número.",
	"Se inverter os números, o resultado é o mesmo. Ex.: 3 + 2 = 5 e 2 + 3 = 5.",
	"Soma é como contar pra frente. Ex.: 4 + 2 é contar dois números após 4.",
	"Se um número for 10, some o outro direto. Ex.: 10 + 5 = 15.",
	"Soma aparece quando juntamos objetos, pessoas ou pontos.",
	"Somar números grandes? Some as dezenas e depois as unidades.",
	"Você pode somar em qualquer ordem, o resultado não muda!",
	"A soma tem como sinal o '+', que significa juntar ou adicionar.",
	"Quando somamos dois números iguais, dizemos que é dobrar. Ex.: 4 + 4 = 8.",
	"Se somar mais de dois números, faça em partes. Ex.: 2 + 3 + 5 = (2 + 3) + 5 = 10.",
	"Se você somar 9, pense em somar 10 e depois tirar 1. Ex.: 9 + 7 = (10 + 7) - 1 = 16."
]


var sub_hints = [
	"Subtração é retirar uma quantidade. Ex.: 5 - 2 = 3.",
	"Quando subtraímos, o número fica menor.",
	"Se subtrair zero, o número continua igual. Ex.: 7 - 0 = 7.",
	"5 - 5 sempre dá zero. Tirou tudo, sobra nada.",
	"Subtração é como contar pra trás. Ex.: 8 - 3 é voltar 3 casas desde o 8.",
	"Pense em subtrair como comer balas. Tinha 6, comeu 2, sobraram 4.",
	"Se o primeiro número for menor que o segundo, o resultado é negativo.",
	"Subtrair é desfazer uma soma. Ex.: 9 - 4 = 5, pois 4 + 5 = 9.",
	"Use os dedos para ajudar a subtrair pequenos números.",
	"Subtrair números grandes? Tire as dezenas, depois as unidades.",
	"O sinal da subtração é '-', que indica tirar ou remover.",
	"Quando subtrai 1, é só pensar no número anterior. Ex.: 7 - 1 = 6.",
	"Se subtrair um número de si mesmo, sempre dá zero. Ex.: 12 - 12 = 0.",
	"Se subtrair 10, é como apagar uma dezena inteira. Ex.: 25 - 10 = 15."
]


var mul_hints = [
	"Multiplicar é repetir uma soma. Ex.: 3 x 2 = 6 (3 + 3).",
	"Qualquer número vezes zero sempre será zero.",
	"Número vezes 1 não muda. Ex.: 7 x 1 = 7.",
	"3 x 4 é o mesmo que 4 x 3. A ordem não muda o resultado.",
	"Multiplicar é como criar grupos iguais. Ex.: 5 x 3 são 5 grupos de 3.",
	"Tabuada ajuda muito na multiplicação. Decore aos poucos.",
	"Multiplicação acelera a soma. Em vez de fazer 2 + 2 + 2, faz 2 x 3.",
	"Se souber multiplicar por 10, fica fácil: só colocar um zero. Ex.: 7 x 10 = 70.",
	"Multiplicar por 5? Sempre dá um número que termina em 5 ou 0.",
	"Multiplicação é usada quando temos conjuntos iguais para contar rápido.",
	"Multiplicar por 2 é o mesmo que dobrar. Ex.: 6 x 2 = 12.",
	"O sinal da multiplicação é 'x' ou '·', que representa agrupar ou repetir.",
	"Multiplicar por 9? O resultado quase sempre tem dígitos que somam 9. Ex.: 9 x 4 = 36 (3 + 6 = 9).",
	"Se multiplicar por números pares, o resultado será par. Ex.: 4 x 5 = 20 (par)."
]


var div_hints = [
	"Dividir é repartir igualmente. Ex.: 6 ÷ 2 = 3 (6 dividido em 2 partes).",
	"Se dividir algo por 1, o resultado é ele mesmo. Ex.: 8 ÷ 1 = 8.",
	"Zero dividido por qualquer número é zero.",
	"Não existe divisão por zero. Isso é impossível.",
	"Dividir é pensar em grupos iguais. Ex.: 12 ÷ 3 = 4 (12 em 3 grupos de 4).",
	"Divisão é a operação inversa da multiplicação. Se 3 x 4 = 12, então 12 ÷ 3 = 4.",
	"Se o divisor for igual ao número, o resultado é 1. Ex.: 9 ÷ 9 = 1.",
	"Dividir por 2 é cortar na metade.",
	"Se o número não dá pra dividir certinho, sobram restos (isso se chama divisão exata ou não exata).",
	"Dividir ajuda quando queremos compartilhar de forma justa.",
	"O sinal da divisão é '÷' ou '/'.",
	"Quando dividimos por 10, é só tirar um zero. Ex.: 70 ÷ 10 = 7.",
	"Se 20 ÷ 4 = 5, significa que 5 x 4 = 20. Multiplicação e divisão são operações irmãs.",
	"Quando não dá pra dividir certinho, podemos pensar em partes menores ou usar números decimais."
]


func _ready() -> void:
	$CanvasLayer.hide()

	if title_label == null:
		print("[ERRO] Não encontrou Label!")
	if hint_text == null:
		print("[ERRO] Não encontrou RichTextLabel!")

func set_gameplay(scene):
	gameplay_scene = scene


func show_hint_for_mode(mode_type: String) -> void:
	mode = mode_type
	var hint := ""

	match mode_type:
		"add":
			title_label.text = "Dica de Soma"
			hint = add_hints[randi() % add_hints.size()]
		"sub":
			title_label.text = "Dica de Subtração"
			hint = sub_hints[randi() % sub_hints.size()]
		"mul":
			title_label.text = "Dica de Multiplicação"
			hint = mul_hints[randi() % mul_hints.size()]
		"div":
			title_label.text = "Dica de Divisão"
			hint = div_hints[randi() % div_hints.size()]
		"all":
			title_label.text = "Dica Geral"
			var all_hints = add_hints + sub_hints + mul_hints + div_hints
			hint = all_hints[randi() % all_hints.size()]
		_:
			title_label.text = "Dica"
			hint = "Tente novamente e você irá melhorar!"

	hint_text.text = hint
	$CanvasLayer.show()


func _on_next_pressed() -> void:
	button_click.play()
	await button_click.finished
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/menu/Selection_mode_menu.tscn")


func hide_tip() -> void:
	$CanvasLayer.hide()
