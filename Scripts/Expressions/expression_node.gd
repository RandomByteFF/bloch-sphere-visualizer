class_name  ExpressionNode


var value : String
var left : ExpressionNode = null
var right : ExpressionNode = null
var takes_two : bool = true
var _backup_value : Complex = Complex.new(1,0)
var _operation : Callable

func _get_operation(text : String) -> Callable:
    match text:
        "+" : return func(a : Complex, b : Complex): return a.add(b)
        "-" : return func(a : Complex, b : Complex): return a.subtract(b)
        "*" : return func(a : Complex, b : Complex): return a.multiply(b)
        "/" : return func(a : Complex, b : Complex): return a.divide(b)
        "^" : return func(a : Complex, b : Complex): return a.power(b)
        _ : return func(a : Complex, _b : Complex): return a


func _get_function(text : String) -> Callable:
    match text:
        # TODO
        "sin" : return func(a : Complex, _b : Complex): return a.sin_of() 
        "cos" : return func(a : Complex, _b : Complex): return a.cos_of()
        "tan" : return func(a : Complex, _b : Complex): return a.tan_of()
        "sqrt" : return func(a : Complex, _b : Complex): return  a.root(Complex.new(2, 0))
        _ : return func(a : Complex, _b : Complex): return  a

var constants = {
    "pi" : Complex.new(PI, 0),
    "e" : Complex.new(exp(1), 0),
    "i" : Complex.new(0, 1)
}

func _evaluate_string(text : String) -> Callable:
    var regex = RegEx.new()
    regex.compile("[0-9.]")

    var result = Complex.new()
    var chars = ""

    for i in range(text.length()):
        var c = text[i]

        # is digit
        if regex.search(c):
            chars += c
        else:
            if chars != "":
                var z = Complex.new(chars.to_float(), 0)
                result.multiply(z)
                chars = ""
            
            if c in constants:
                var z = constants.get(c)
                result.multiply(z)
                chars = ""
            else:
                chars += c

    return func(_a, _b): return result

func _init(token : Token):
    self.value = token.value

    if token.type == Token.TokenType.OPERATOR:
        _operation = _get_operation(token.value)
        _backup_value = Complex.new(0, 0) if token.value == "+" or token.value == "-" else Complex.new(1, 0)
    elif token.type == Token.TokenType.FUNCTION:
        takes_two = false    
        _operation = _get_function(token.value)        
    else:
        takes_two = false
        _operation = _evaluate_string(token.value)
    
func evaluate() -> Complex:
    var a = left.evaluate()
    var b = right.evaluate()

    if a == null:
        a = _backup_value
    if b == null:
        b = _backup_value

    return _operation.call(a, b)