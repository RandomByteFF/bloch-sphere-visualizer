class_name Gate extends MatrixComplex2D

#
# Well known quantum logic gates
#

static var X: MatrixComplex2D = MatrixComplex2D.new_real(
	0, 1,
	1, 0
)

static var Y: MatrixComplex2D = MatrixComplex2D.new(
	Complex.new(0), Complex.new(0, -1),
	Complex.new(0, 1), Complex.new(0)
)

static var Z: MatrixComplex2D = MatrixComplex2D.new_real(
	1, 0,
	0, -1
)

static var H: MatrixComplex2D = MatrixComplex2D.new_real(
	1, 1,
	1, -1
).multiply_scalar(1 / sqrt(2))

static func P(phi: float = PI) -> MatrixComplex2D:
	return MatrixComplex2D.new(
		Complex.new(1), Complex.new(0),
		Complex.new(0), Complex.new_polar(1, phi) # = 1 * e^(i * phi)
	)