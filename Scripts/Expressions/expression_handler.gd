class_name ExpressionHandler

static func evaluate(text : String) -> Complex:
    text = text.replace(",", ".").replace("_", "").to_lower().strip_edges()
    
    var tokens = Tokenizer.tokenize(text)

    return Complex.new(0, 0)
