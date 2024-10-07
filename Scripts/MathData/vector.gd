class_name VectorComplex2D extends Object
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

## Multiplies by `s` scalar
func multiply_scalar(s: float) -> VectorComplex2D:
	return VectorComplex2D.new(x.multiply_real(s), y.multiply_real(s))

## Replaces the [] operator overload
func get_value(i: int) -> Complex:
	assert(i < 2 && i >= 0, "Error: Invalid index for VectorComplex2D")
	return x if i == 0 else y
