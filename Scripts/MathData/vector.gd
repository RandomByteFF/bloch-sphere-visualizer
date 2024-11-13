class_name VectorComplex2D 
## Class to handle 2D vectors containing complex numbers

#
# Properties
#

var x: Complex
var y: Complex

#
# Constructors
#

func _init(X: Complex = Complex.new(), Y: Complex = Complex.new()) -> void:
	x = X
	y = Y

static func new_real(X: float = 0, Y: float = 1) -> VectorComplex2D:
	return VectorComplex2D.new(Complex.new(X), Complex.new(Y))

#
# Operations
#

## Returns the sum of this vector with `v`
func add(v: VectorComplex2D) -> VectorComplex2D:
	return VectorComplex2D.new(x.add(v.x), y.add(v.y))

## Multiplies by `v` vector from the right side (V * v)
## *Obviously the result is the same as dot product*
func multiply_vec(v: VectorComplex2D) -> Complex:
	return x.multiply(v.x).add(y.multiply(v.y))

## Multiplies by `m` matrix from the right side (V * m as if V was row wise)
func multiply_mat(m: MatrixComplex2D) -> VectorComplex2D:
	return VectorComplex2D.new(
		x.multiply(m._a).add(y.multiply(m._c)),
		x.multiply(m._b).add(y.multiply(m._d)),
	)

func normalize() -> VectorComplex2D:
	var norm = Complex.new(sqrt(x.abs_squared() + y.abs_squared()), 0)

	if(norm.re == 0):
		return VectorComplex2D.new()

	return VectorComplex2D.new(x.divide(norm), y.divide(norm))

## Multiplies by `s` scalar
func multiply_scalar(s: float) -> VectorComplex2D:
	return VectorComplex2D.new(x.multiply_real(s), y.multiply_real(s))

## Replaces the [] operator overload
func get_value(i: int) -> Complex:
	assert(i < 2 && i >= 0, "Error: Invalid index for VectorComplex2D")
	return x if i == 0 else y

func is_equal_approx(v: VectorComplex2D) -> bool:
	return is_equal_approx(x.re, v.x.re) and is_equal_approx(y.re, v.y.re) and is_equal_approx(x.im, v.x.im) and is_equal_approx(y.im, v.y.im)

func _to_string() -> String:
	return "(%s, %s)" % [x.to_string(), y.to_string()]
	