extends Node

func generate_operation(mode: String = "add") -> Dictionary:
	var a = 0
	var b = 0
	var operation_type = ""

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
			operation_type = ["+", "-"].pick_random()
		"add_mul":
			operation_type = ["+", "*"].pick_random()
		"sub_div":
			operation_type = ["-", "/"].pick_random()
		"mul_div":
			operation_type = ["*", "/"].pick_random()
		"all":
			a = randi() % 10
			b = randi() % 10
			operation_type = ["+", "-", "*", "/"].pick_random()

	var question = ""
	var answer = 0

	match operation_type:
		"+":
			question = "%d + %d = ?" % [a, b]
			answer = a + b
		"-":
			if a < b:
				var temp = a
				a = b
				b = temp
			question = "%d - %d = ?" % [a, b]
			answer = a - b
		"*":
			question = "%d × %d = ?" % [a, b]
			answer = a * b
		"/":
			b = b if b != 0 else 1
			var result = a * b  # Garante divisão exata
			question = "%d ÷ %d = ?" % [result, b]
			answer = result / b

	return {
		"question": question,
		"answer": answer
	}
