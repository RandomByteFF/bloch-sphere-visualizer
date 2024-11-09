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

static var U: Gate = Gate.new(
	"Unitary", "U",
	MatrixComplex2D.new_real(
		1, 0,
		0, 1
	)
)

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

func interpolate(qubit : Qubit, steps : int = 15) -> Dictionary:
	var curve = Curve3D.new()

	# the result of matrix multiplication 
	var last = self.value.multiply_vec(qubit)

	var t = 0
	var dt = 1.0 / steps

	for i in range(steps):
		# step = first * t + last * (1 - t)
		var step = qubit.multiply_scalar(t).add(last.multiply_scalar(1-t))

		curve.add_point(Qubit.from_vec(step).to_bloch_spehere_pos())
		t += dt

	return { "curve": curve, "position": Qubit.from_vec(last) }
