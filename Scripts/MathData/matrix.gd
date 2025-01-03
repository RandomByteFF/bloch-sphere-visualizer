class_name MatrixComplex2D

#
# Properties
# Using a,b,c,d instead of array for operation cleannes
#

var a: Complex
var b: Complex
var c: Complex
var d: Complex

#
# Constructor
#

func _init(
	A: Complex = Complex.new(), B: Complex = Complex.new(),
	C: Complex = Complex.new(), D: Complex = Complex.new(),
) -> void:
	a = A
	b = B
	c = C
	d = D

static func new_real(
	A: float = 0,
	B: float = 0,
	C: float = 0,
	D: float = 0,
) -> MatrixComplex2D:
	return MatrixComplex2D.new(
		Complex.new(A),
		Complex.new(B),
		Complex.new(C),
		Complex.new(D),
	)
	
#
# Operations
#

## Sums this matrix with `m` and returns the result
func add(m: MatrixComplex2D) -> MatrixComplex2D:
	return MatrixComplex2D.new(
		a.add(m.a), b.add(m.b),
		c.add(m.c), d.add(m.d),
	)

## Multiplies by `v` vector from the right side (as a column vector - M * v)
func multiply_vec(v: VectorComplex2D) -> VectorComplex2D:
	return VectorComplex2D.new(
		a.multiply(v.x).add(b.multiply(v.y)), # a * x + b * y
		c.multiply(v.x).add(d.multiply(v.y)), # c * x + d * y
	)

## Multiplies by `m` matrix from the right side (M * m)
func multiply_mat(m: MatrixComplex2D) -> MatrixComplex2D:
	return MatrixComplex2D.new(
		a.multiply(m.a).add(b.multiply(m.c)),
		a.multiply(m.b).add(b.multiply(m.d)),
		c.multiply(m.a).add(d.multiply(m.c)),
		c.multiply(m.b).add(d.multiply(m.d)),
	)
 
## Multiplies by `s` scalar
func multiply_scalar(s: float) -> MatrixComplex2D:
	return MatrixComplex2D.new(
		a.multiply_real(s), b.multiply_real(s),
		c.multiply_real(s), d.multiply_real(s),
	)

func transpose() -> MatrixComplex2D:
	return MatrixComplex2D.new(a, c, b, d)

func adjugate() -> MatrixComplex2D:
	return MatrixComplex2D.new(a.conjugate(), c.conjugate(), b.conjugate(), d.conjugate())

func _is_unitary() -> bool:
	var m = self.multiply_mat(self.adjugate())

	# checking if its Identity
	var no_imaginary = is_equal_approx(m.a.im, 0.0) and is_equal_approx(m.b.im, 0.0) and is_equal_approx(m.c.im, 0.0) and is_equal_approx(m.d.im, 0.0)
	return is_equal_approx(m.a.re, 1.0) and is_equal_approx(m.b.re, 0.0) and is_equal_approx(m.c.re, 0.0) and is_equal_approx(m.d.re, 1.0) and no_imaginary

## Replaces the [] operator overload
func get_value(x: int, y: int) -> Complex:
	assert(x >= 0 && x < 2 && y >= 0 && y < 2, "Error: Invalid index for MatrixComplex2D")
	
	if x == 0:
		return a if y == 0 else b
	else:
		return c if y == 0 else d
