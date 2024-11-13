class_name ExpressionHandler



static func evaluate(text : String) -> Complex:
    text = text.replace(",", ".").replace("_", "").to_lower().strip_edges()

    var tokens = Tokenizer.tokenize(text)
    tokens = Tokenizer.insert_multiplication(tokens)

    var parsed = Parser.parse(tokens)
    if parsed.size() == 0:
        return Complex.new(0, 0)
    
    # building the AST
    var stack = []
    for node in parsed:
        if node.takes_two:
            var right = stack.pop_back()
            var left = stack.pop_back()
            node.left = left
            node.right = right
        stack.append(node)

    return stack[0].evaluate()
