extends Node

# Gera uma operação matemática aleatória com base no modo escolhido (ex: soma, subtração, multiplicação, divisão)
func generate_operation(mode: String = "add") -> Dictionary:
	var a = 0  # Primeiro número da operação
	var b = 0  # Segundo número da operação
	var operation_type = ""  # Tipo de operação: "+", "-", "*", ou "/"

	# Define os números e o tipo de operação conforme o modo escolhido
	match mode:
		"add":
			# Soma com números até 49
			a = randi() % 50
			b = randi() % 50
			operation_type = "+"
		"sub":
			# Subtração com números até 49
			a = randi() % 50
			b = randi() % 50
			operation_type = "-"
		"mul":
			# Multiplicação com números até 9 para facilitar
			a = randi() % 10
			b = randi() % 10
			operation_type = "*"
		"div":
			# Divisão com números até 9, cuidado com divisão por zero depois
			a = randi() % 10
			b = randi() % 10
			operation_type = "/"
		"add_sub":
			# Escolhe aleatoriamente entre soma e subtração
			operation_type = ["+", "-"].pick_random()
			a = randi() % 50
			b = randi() % 50
		"add_mul":
			# Escolhe entre soma (números maiores) ou multiplicação (números menores)
			operation_type = ["+", "*"].pick_random()
			match operation_type:
				"+":  
					a = randi() % 50
					b = randi() % 50
				"*":  
					a = randi() % 10
					b = randi() % 10
		"sub_div":
			# Escolhe entre subtração ou divisão
			operation_type = ["-", "/"].pick_random()
			match operation_type:
				"-":
					a = randi() % 50
					b = randi() % 50
				"/":
					a = randi() % 10
					b = randi() % 10
		"mul_div":
			# Escolhe entre multiplicação ou divisão, ambos com números até 9
			operation_type = ["*", "/"].pick_random()
			a = randi() % 10
			b = randi() % 10
		"all":
			# Pode ser qualquer operação
			operation_type = ["+", "-", "*", "/"].pick_random()
			match operation_type:
				"+", "-":
					a = randi() % 50
					b = randi() % 50
				"*", "/":
					a = randi() % 10
					b = randi() % 10

	var question = ""  # String que representa a operação para exibir ao jogador
	var answer = 0     # Resultado correto da operação

	# Monta a string da pergunta e calcula a resposta correta conforme o tipo da operação
	match operation_type:
		"+":  # Soma
			question = "%d + %d = ?" % [a, b]
			answer = a + b
		"-":  # Subtração
			if a < b:
				# Garante que a operação não resulte em número negativo, trocando a e b se necessário
				var temp = a
				a = b
				b = temp  
			question = "%d - %d = ?" % [a, b]
			answer = a - b
		"*":  # Multiplicação
			question = "%d × %d = ?" % [a, b]
			answer = a * b
		"/":  # Divisão (faz divisão exata para evitar números decimais)
			# Para garantir divisão exata:
			a = randi() % 10
			b = (randi() % 9) + 1  # b nunca será zero
			var result = a * b     # Multiplica para garantir que resultado / b seja inteiro
			question = "%d ÷ %d = ?" % [result, b]
			answer = result / b

	# Retorna um dicionário com a pergunta e a resposta correta
	return {
		"question": question,
		"answer": answer
	}
