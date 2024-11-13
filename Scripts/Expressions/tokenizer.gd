class_name Tokenizer

static var brackets = ["(", ")"]
static var operators = {
    "+": 0, 
    "-": 0, 
    "*": 1, 
    "/": 1, 
    "^": 2,
}
static var functions = ["sin", "cos", "tan", "sqrt"]
static var values = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "i", "pi", "j", "e"]

static var function_found = ""

#! the logic only works when none of the functions have the same last character
static func _find_function(last_char : String) -> bool:
    var filtered = functions.filter(func(name): return name.ends_with(last_char))

    if filtered.size() == 0:
        return false
    
    function_found = filtered[0]
    return true

static func tokenize(text : String) -> Array[Token]:
    var tokens = []
    var length = 0

    var i = 0
    var found = []

    while i < text.length():
        var current_char = text[i]

        # handling brackets
        if current_char in brackets:
            var type = Token.TokenType.BRACKET_OPEN if current_char == "(" else Token.TokenType.BRACKET_CLOSE
            var precedence = 10
            tokens.append(Token.new(type, current_char, precedence))

        # handling operators
        elif current_char in operators:
            var precedence = operators.get(current_char)
            tokens.append(Token.new(Token.TokenType.OPERATOR, current_char, precedence))

        # handling functions
        elif found.size() >= 2 and _find_function(current_char):
            # if the last n characters are a function name
            if found.join("").ends_with(function_found):
                # remove the previous characters of the function
                found = found.slice(0, found.size() - (function_found.size() - 1)) 
                
                var precedence = 10
                tokens.append(Token.new(Token.TokenType.FUNCTION, function_found, precedence))
            else:
                found.append(current_char)
        
        # handling values
        elif current_char != " ":
            found.append(current_char)
        
        # if we have added a new token or a new group starts we should save the value
        # 1. eg.: ... 12i+... or ... 2sin(...)...
        # 2. eg.: ... 1/2 e...
        if (length < tokens.size() or current_char == " ") and found.size() > 0:
            tokens.append(Token.new(Token.TokenType.VALUE, found.join("")))
            found = []

        length = tokens.size()
        i+= 1

    if found.size() > 0:
        tokens.append(Token.new(Token.TokenType.VALUE, found.join("")))

    return tokens

# Examples for each rule
# 1. `2 pi` (this also leads to `1 000 = 1 * 0 = 0` but the alternative notation is supported: `1_000`)
# 2. `2 cos(...)`
# 3. `2(...)`
# ---
# 4. `(...) pi`
# 5. `(...) sin()`
# 6. `(...) (...)`
static var _insert_rules = {
    Token.TokenType.VALUE: [
        Token.TokenType.VALUE, 
        Token.TokenType.FUNCTION,
        Token.TokenType.BRACKET_OPEN,
    ],
    Token.TokenType.BRACKET_CLOSE: [
        Token.TokenType.VALUE, 
        Token.TokenType.FUNCTION,
        Token.TokenType.BRACKET_OPEN,
    ]
}

static func insert_multiplication(tokens : Array[Token]) -> Array[Token]:
    var i := 0     

    while i < tokens.size() - 1:
        var expected_next = _insert_rules.get(tokens[i].type)

        if (expected_next != null) and (tokens[i+1].type in expected_next):
            tokens.insert(i, Token.new(Token.TokenType.OPERATOR, '*'))

        i += 1
    return tokens
