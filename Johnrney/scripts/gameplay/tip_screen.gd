extends Control

signal hint_closed

@onready var button_click = $buttonclick
@onready var title_label = $CanvasLayer/Label
@onready var hint_text = $CanvasLayer/RichTextLabel

var mode := ""
var gameplay_scene

var add_hints = [
	"Caso a soma de uma posição decimal ultrapasse 10, escreva a unidade e mande a dezena para a próxima posição. Ex.: 91+9=100",
	"Quando você soma dois números positivos, o resultado sempre cresce.",
	"Use os dedos para somar pequenas quantidades.",
	"2 + 0 continua sendo 2. Ou seja, somar com zero não muda o número.",
	"Se inverter os números, o resultado é o mesmo. Ex.: 3 + 2 = 5 e 2 + 3 = 5. Essa é a propriedade comutativa.",
	"Soma entre dois inteiros é como ‘pegar’ o sucessor de um dos números x vezes, sendo x o outro número da soma. Ou seja, 4 + 2 é como o sucessor do sucessor de 4, que é 6.",
	"Se um número for 10 e o outro um algarismo unitário, combine-os. Ex.: 10 + 5 = 15.",
	"Soma aparece quando juntamos objetos, pessoas ou pontos.",
	"Dúvida em somar números grandes? Comece das unidades e vá progredindo de posição para dezenas, centenas, etc.",
	"Lembre-se da comutatividade: você pode somar em qualquer ordem e o resultado não mudará!",
	“O símbolo ‘+’ foi usado pela primeira vez pelo francês Nicole d’Oresme, entre 1356 e 1361.",
	"A soma entre dois números iguais é a mesma coisa que multiplicar por dois, ou seja, dobrar. Ex.: 4 + 4 = 8.",
	"Caso precise somar mais de dois números, você pode fazer em partes. Ex.: 2 + 3 + 5 = (2 + 3) + 5 = 10. Essa é a propriedade associativa.",
	"Se você quiser somar um número positivo com 9, pense em somar por 10 e depois subtrair por 1. Ex.: 9 + 7 = (10 + 7) - 1 = 16."



var sub_hints = [
	"Subtração é retirar uma quantidade. Ex.: 5 - 2 = 3.",
"Subtração é a operação oposta da adição. Ou seja, todas as propriedades da última se aplicam à primeira.",
"Subtrair é a mesma coisa de somar com o oposto. Ex.: a -b = a + (-b)",
	“Caso ambos os números de uma subtração forem negativos, some-os e coloque o sinal de ‘-’ no final. Ex.: -25 -10 = -35”,
	“Um número ‘a’ menos um número negativo ‘b’ é a mesma coisa que ‘a+b’. Ex.: 10 -(-10) = 10 + 10 = 20.”
	"Quando subtraímos ‘a-b’ positivos, se ‘a’ for maior que ‘b’, o resultado será menor do que ‘a’. Ex.: 20 - 5 = 15.",
	"Na subtração por zero o número continua igual. Ex.: 7 - 0 = 7. Isso significa que zero é o elemento identidade da subtração.",
	"Um número menos ele mesmo sempre dá zero. Tirou tudo, não sobra nada.",
	"Subtração é como contar pra trás. Ex.: 8 - 3 é voltar 3 algarismos na linha dos números inteiros desde o 8.",
	"Se o primeiro número for menor que o segundo, o resultado é negativo. Ex.: 5-9 = -4.",
	"Para subtrair dois números com sinais diferentes, pegue o número de maior módulo , subtraia pelo de menor e adicione o sinal do de maior módulo ao resultado. Ex.: 37 - 50 = -(50 - 37) = -13",
	"Subtrair é o caminho inverso da soma. Ex.: 9 - 4 = 5, pois 4 + 5 = 9.",
	"Use os dedos para ajudar a subtrair pequenos números.",
	"Os primeiros a usar ‘+’ e ‘-’ como símbolos de operações foram o holandês Giel van der Hoecke, em 1514, e o alemão Henricus Grammateus, em 1518.",
	"Quando se subtrai por 1, é só pensar no antecessor do outro número. Ex.: 7 - 1 = 6 já que o antecessor de 7 é 6.",
	“O resultado da subtração de um número por ele mesmo sempre dá zero. Ex.: 12 - 12 = 0.",
	"Subtrair por 10 é como apagar uma dezena inteira. Ex.: 25 - 10 = 15."
]


var mul_hints = [
	"Multiplicar é repetir uma soma pelo número de vezes indicado. Ou seja, a x b = a + a + a + a… ‘b’ vezes. Ex.: 3 x 4 = 3 + 3 + 3 + 3 = 12.",
	"Qualquer número vezes zero sempre será zero. Ex.: a x 0 = 0",
"O ‘x’ nem sempre é utilizado para a multiplicação. Utiliza-se também ‘*’, ‘•’ ou parênteses. Ex.: 3*6 = 18, 7•3 = 21 e 5(10) = 50",
"A propriedade distributiva diz que a*(b+c) = ab + ac",
	"O resultado de um número vezes 1 não muda. Ex.: 7 x 1 = 7. Logo, 1 é o elemento neutro da multiplicação.",
	“A propriedade de fechamento diz que, se ‘a’ e ‘b’ pertencem ao conjunto dos números reais, ‘a x b’ também será um número real.”,
	"3 x 4 é o mesmo que 4 x 3. A ordem não muda o resultado. Essa é a propriedade comutativa.",
	"A tabuada ajuda muito na multiplicação. Decore-a aos poucos, jogando JOHNrney.",
	"Multiplicação acelera a soma, caso você saiba a tabuada. Em vez de fazer 2 + 2 + 2, faça 2 x 3.",
	"Multiplicar um número inteiro por 10 é fácil: só colocar um zero na frente. Ex.: 7 x 10 = 70.",
	"Ao multiplicar um número inteiro por 5 o resultado sempre termina em 5 ou 0.",
	"Um número inteiro multiplicado por 2 ou por seus múltiplos sempre terá o final par. Ex.: 6 x 2 = 12.",
	"O resultado da multiplicação por 9 quase sempre tem dígitos que somam 9. Ex.: 9 x 4 = 36 (3 + 6 = 9).",
	"A regra de sinais diz que, na multiplicação de dois números, sinais iguais dão um resultado positivo e sinais diferentes dão um resultado negativo."
]


var div_hints = [
	"Divisão é a operação oposta à multiplicação.",
	“Qualquer número racional pode ser escrito como uma divisão de dois números. Ex.: 13,5 = 27/2”,
	"Ao dividir algo por 1, o resultado é ele mesmo. Ex.: 8 ÷ 1 = 8.",
	"Zero dividido por qualquer número que não seja ele mesmo é zero.",
	"Não existe divisão de por zero. Isso é impossível.",
	"Dividir é pensar em grupos iguais. Ex.: 12 ÷ 3 = 4 (12 em 3 grupos de 4).",
	"Divisão é a operação inversa da multiplicação. Se 3 x 4 = 12, então 12 ÷ 3 = 4. Caso queira ver se o resultado está certo, você pode usar essa propriedade para testá-lo.",
	"Se o divisor for igual ao número, exceto no caso de zero, o resultado é 1. Ex.: 9 ÷ 9 = 1.",
	"Dividir por 2 é como cortar na metade.",
	"Se uma divisão não tem como resultado um número inteiro, sobra o resto. Este tipo de divisão se chama não exata).",
	"Dividir ajuda quando queremos compartilhar de forma justa entre amigos a conta do jantar.",
	"O sinal da divisão é '÷' ou '/'”,
	"O sinal '÷' representa uma fração onde as bolinhas ‘•’ substituem os lugares dos números.” ,
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
