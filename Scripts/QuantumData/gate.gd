class_name Gate extends MatrixComplex2D

#
# Properties
#

var name: String
var abbreviation: String
static var p_id: int = 0

#
# Constructor
# 

func _init(
	gate_name: String,
	abbr: String = "",
	A: Complex = Complex.new(),
	B: Complex = Complex.new(),
	C: Complex = Complex.new(),
	D: Complex = Complex.new(),
):
	assert(name.length() > 0, "Error: Gate name can not be empty")

	name = gate_name
	abbreviation = abbr if !abbr.is_empty() else name[0].to_upper()
	super(A, B, C, D)

## Creates a new gate with the given name from 
static func new_real(
	gate_name: String,
	abbr: String,
	A: float = 0,
	B: float = 0,
	C: float = 0,
	D: float = 0,
) -> Gate:
	return Gate.new(
		gate_name,
		abbr,
		Complex.new(A),
		Complex.new(B),
		Complex.new(C),
		Complex.new(D),
	)

#
# Well known quantum logic gates
#

static var X: Gate = Gate.new_real(
	"Pauli-X", "X",
	0, 1,
	1, 0
)

static var Y: Gate = Gate.new(
	"Pauli-Y", "Y",
	Complex.new(0), Complex.new(0, -1),
	Complex.new(0, 1), Complex.new(0)
)

static var Z: Gate = Gate.new_real(
	"Pauli-Z", "Z",
	1, 0,
	0, -1
)

static var H: Gate = Gate.new_real(
	"Hadamard", "H",
	1, 1,
	1, -1
).multiply_scalar(1 / sqrt(2))

static func P(phi: float = PI) -> Gate:
	p_id += 1
	var display_name = "Phase (%.02f)" % phi
	var display_abbr = "P%d" % p_id

	return Gate.new(
		display_name, display_abbr,
		Complex.new(1), Complex.new(0),
		Complex.new(0), Complex.new_polar(1, phi) # = 1 * e^(i * phi)
	)

#
# operations
#
func getAbbreviation() -> String:
	return name[0].to_upper()