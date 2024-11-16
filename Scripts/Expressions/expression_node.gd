class_name  ExpressionNode


var token : Token = null
var left : ExpressionNode = null
var right : ExpressionNode = null
var takes : int = 0
var _backup_value : Complex = Complex.new(1)
var _operation : Callable = func(): return 

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
		"sin" : return func(a : Complex, _b : Complex): return a.sin_of() 
		"cos" : return func(a : Complex, _b : Complex): return a.cos_of()
		"tan" : return func(a : Complex, _b : Complex): return a.tan_of()
		"sqrt" : return func(a : Complex, _b : Complex): return  a.root(Complex.new(2))
		_ : return func(a : Complex, _b : Complex): return  a

var constants = {
	"pi" : Complex.new(PI),
	"e" : Complex.new(exp(1)),
	"i" : Complex.new(0, 1)
}

func _evaluate_string(text : String) -> Complex:
	var regex = RegEx.new()
	regex.compile("[0-9.]")

	var result = Complex.new(1)
	var chars = ""
	# chars only contains digits
	var has_digits := false

	for i in range(text.length()):
		var c = text[i]

		# is digit
		if regex.search(c):
			chars += c
			has_digits = true
		else:
			# when the upcoming is not digit
			if has_digits:
				var z = Complex.new(chars.to_float())
				result = result.multiply(z)
				chars = ""

			chars += c
			has_digits = false
			
			#! the constants can be each others prefixes
			if chars in constants:
				var z = constants.get(chars)
				result = result.multiply(z)
				chars = ""
				
	if has_digits:
		var z = Complex.new(chars.to_float())
		result = result.multiply(z)
		chars = ""

	if chars.length() > 0:
		# TODO show error if needed
		print("Invalid string %s" % chars)
		return Complex.new()
				
	return result

@warning_ignore("shadowed_variable")
func _init(token : Token):
	self.token = token

	if token.type == Token.TokenType.OPERATOR:
		_operation = _get_operation(token.value)
		_backup_value = Complex.new(0) if (token.value == "+" or token.value == "-") else Complex.new(1)
		takes = 2
	elif token.type == Token.TokenType.FUNCTION:
		takes = 1
		_operation = _get_function(token.value)        
	else:
		takes = 0
		_operation = func(): return 
	
func evaluate() -> Complex:
	if token.type == Token.TokenType.VALUE:
		return _evaluate_string(token.value)

	if takes == 1 and left == null:
		return Complex.new()
	
	var a = _backup_value
	var b = _backup_value

	if left != null:
		a = left.evaluate()
	if right != null:
		b = right.evaluate()

	return _operation.call(a, b)
