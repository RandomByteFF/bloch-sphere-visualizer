class_name ExpressionHandler

static func evaluate(text : String) -> Complex:
	text = text.replace(",", ".").replace("_", "").to_lower().strip_edges()
	
	if text == "":
		return Complex.new()

	var tokens = Tokenizer.tokenize(text)
	
	tokens = Tokenizer.insert_multiplication(tokens)

	#* for debugging:
	#print(tokens.map(func(e): return e.value))

	var parsed = Parser.parse(tokens)

	#* for debugging:
	#print(parsed.map(func(e): return e.token.value))

	if parsed.size() == 0:
		return Complex.new()
	
	# building the AST
	var stack = []
	for node in parsed:
		if node.takes == 1:
			# if it has no child
			if stack.size() == 0:
				return Complex.new()
			node.left = stack.pop_back()

		elif node.takes == 2:
			var right = stack.pop_back() if stack.size() > 0 else null
			var left = stack.pop_back() if stack.size() > 0 else null
			node.left = left
			node.right = right
		stack.append(node)
		
	return stack[0].evaluate()
