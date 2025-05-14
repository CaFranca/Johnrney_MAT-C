extends Node

# Gera uma operação matemática aleatória com base no modo escolhido
func generate_operation(mode: String = "add") -> Dictionary:
	var a = 0  # Primeiro número da operação
	var b = 0  # Segundo número da operação
	var operation_type = ""  # Tipo de operação: "+", "-", "*", ou "/"

	# Define os números e o tipo de operação com base no modo
	match mode:
		"add":
			a = randi() % 50
			b = randi() % 50
			operation_type = "+"
		"sub":
			a = randi() % 50
			b = randi() % 50
			operation_type = "-"
		"mul":
			a = randi() % 10
			b = randi() % 10
			operation_type = "*"
		"div":
			a = randi() % 10
			b = randi() % 10
			operation_type = "/"
		"add_sub":
			operation_type = ["+", "-"].pick_random()  # Escolhe entre soma ou subtração
			a = randi() % 50
			b = randi() % 50
		"add_mul":
			operation_type = ["+", "*"].pick_random()  # Escolhe entre soma ou multiplicação
			match operation_type:
				"+":  # Soma usa números maiores
					a = randi() % 50
					b = randi() % 50
				"*":  # Multiplicação usa números menores
					a = randi() % 10
					b = randi() % 10
		"sub_div":
			operation_type = ["-", "/"].pick_random()  # Escolhe entre subtração ou divisão
			match operation_type:
				"-":
					a = randi() % 50
					b = randi() % 50
				"/":
					a = randi() % 10
					b = randi() % 10
		"mul_div":
			operation_type = ["*", "/"].pick_random()  # Escolhe entre multiplicação ou divisão
			a = randi() % 10
			b = randi() % 10
		"all":
			operation_type = ["+", "-", "*", "/"].pick_random()  # Qualquer operação
			match operation_type:
				"+", "-":
					a = randi() % 50
					b = randi() % 50
				"*", "/":
					a = randi() % 10
					b = randi() % 10

	var question = ""  # Texto da pergunta a ser exibido
	var answer = 0     # Resposta correta da operação

	# Monta a pergunta e calcula a resposta
	match operation_type:
		"+":  # Soma
			question = "%d + %d = ?" % [a, b]
			answer = a + b
		"-":  # Subtração
			if a < b:
				var temp = a
				a = b
				b = temp  # Garante que o resultado seja positivo
			question = "%d - %d = ?" % [a, b]
			answer = a - b
		"*":  # Multiplicação
			question = "%d × %d = ?" % [a, b]
			answer = a * b
		"/":  # Divisão (gera divisão exata para evitar casas decimais)
			a = randi() % 10
			b = (randi() % 9) + 1  # Garante que b nunca será 0
			var result = a * b     # Garante que a divisão seja exata
			question = "%d ÷ %d = ?" % [result, b]
			answer = result / b

	# Retorna a operação como um dicionário com a pergunta e a resposta
	return {
		"question": question,
		"answer": answer
	}
