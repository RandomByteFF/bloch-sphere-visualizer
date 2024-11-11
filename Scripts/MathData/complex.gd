class_name Complex
## Class to handle complex numbers

#
# Properties
#

var re: float
var im: float

#
# Constructors
#

func _init(real: float = 0.0, imaginary: float = 0.0) -> void:
	re = real
	im = imaginary

## Creates a complex number from exponential / trigonometric format phi is in rad
##
## `r * e^{i * phi}` or `r * (cos(phi) + i * sin(phi))`
static func new_polar(r: float = 0.0, phi: float = 0.0) -> Complex:
	var a = r * cos(phi)
	var b = r * sin(phi)
	return Complex.new(a, b)

#
# Operations
#

func conjugate() -> Complex:
	return Complex.new(re, -im)
	
func add(b: Complex) -> Complex:
	return Complex.new(re + b.re, im + b.im)
	
func subtract(b: Complex) -> Complex:
	return Complex.new(re - b.re, im - b.im)

func multiply(b: Complex) -> Complex:
	return Complex.new(
		(re * b.re - im * b.im),
		(re * b.im + im * b.re),
	)

func multiply_real(s : float) -> Complex:
	return Complex.new(
		re * s,
		im * s,
	)

func divide(b: Complex) -> Complex:
	# denominator
	var d = b.re * b.re + b.im * b.im

	if d == 0:
		push_error("Division by zero")
		return Complex.new(0, 0)
	
	return Complex.new(
		(re * b.re + im * b.im) / d,
		(im * b.re - re * b.im) / d,
	)
	
func power(n: float) -> Complex:
	var p = get_polar()

	return Complex.new_polar(
		pow(p["r"], n),
		p["phi"] * n,

	)

func root(n: int) -> Complex:
	return power(1.0 / n)

## Returns |z|^2 for a z Complex number (`|z|^2 = zz^* = x^2 + y^2`)
func abs_squared() -> float:
	return re * re + im * im

## Returns `r` and `phi` for the exponential and trigometrical format
func get_polar():
	return {
		"r": sqrt(abs_squared()), # sqrt(x^2 + y^2)
		"phi": atan2(im, re),
	}

func _to_string() -> String:
	return "%f + %fi" % [re, im]
