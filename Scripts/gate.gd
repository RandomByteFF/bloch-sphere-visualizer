class_name Gate

#
# Properties
#

var name: String
var abbreviation: String
var value : MatrixComplex2D
# todo assign colors if needed
static var p_id: int = 0


#
# Constructor
# 

func _init(
	gate_name: String,
	abbr: String = "",
	matrix : MatrixComplex2D = MatrixComplex2D.new()
):
	assert(gate_name.length() > 0, "Error: Gate name can not be empty")

	name = gate_name
	abbreviation = abbr if !abbr.is_empty() else name[0].to_upper()
	value =  matrix

#
# Well known quantum logic gates
#

static var X: Gate = Gate.new(
	"Pauli-X", "X",
	MatrixComplex2D.new_real(
		0, 1,
		1, 0
	)
)

static var Y: Gate = Gate.new(
	"Pauli-Y", "Y",
	MatrixComplex2D.new(
		Complex.new(0), Complex.new(0, -1),
		Complex.new(0, 1), Complex.new(0)
	)
)

static var Z: Gate = Gate.new(
	"Pauli-Z", "Z",
	MatrixComplex2D.new_real(
		1, 0,
		0, -1
	)
)

static var H: Gate = Gate.new(
	"Hadamard", "H",
	MatrixComplex2D.new_real(
		1, 1,
		1, -1
	).multiply_scalar(1 / sqrt(2))
)

static func P(phi: float = PI) -> Gate:
	p_id += 1
	var display_name = "Phase (%.02f)" % phi
	var display_abbr = "P%d" % p_id

	return Gate.new(
		display_name, display_abbr,
		MatrixComplex2D.new(
			Complex.new(1), Complex.new(0),
			Complex.new(0), Complex.new_polar(1, phi) # 1 * e^(i * phi)
		)
	)

#
# operations
#

func interpolate(qubit : Qubit, steps : int = 15) -> Curve3D:
	var result = Curve3D.new()
	var last = value.multiply_vec(qubit.value)

	for t in range(0.0, 1.0, 1.0 / steps):
		var step = qubit.value.multiply_scalar(t).add(last.multiply_scalar(1-t))
		result.add_point((step as Qubit).to_bloch_spehere())

	return result
