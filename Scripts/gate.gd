class_name Gate

#
# Properties
#

var name: String
var abbreviation: String
var value : MatrixComplex2D
var is_unitary : bool
var cache : Dictionary = {}
static var p_id: int = 0
static var sphere_radius: float = 0.5

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
	value = matrix

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

# The idea comes from: https://quantumcomputing.stackexchange.com/questions/33184/finding-the-rotation-angle-theta-of-a-2x2-unitary-matrix
func _get_rotation():
	# | a + d | for complex numbers is the trace of the matrix
	var trace = value.a.add(value.d)
	var trace_length = sqrt(trace.abs_squared())

	# theta = 2 * acos((a + d) / 2)
	var angle = 2 * acos(trace_length / 2)

	# if it's on the other side of the circle
	if trace.im < 0:
		angle = 2 * PI - angle

	var scale = sin(angle / 2)
	var scale_j = Complex.new(0, scale).multiply_real(2)

	if is_zero_approx(scale):
		return {
			"angle": 0,
			"axis": Vector3(0, 0, 1)
		}

	# a_x = (b + c) / scale
	# a_y = (b - c) / scale
	# a_z = (a - d) / scale	
	var x = value.b.add(value.c).divide(scale_j)
	var y = value.b.subtract(value.c).multiply_real(1 / (2 * scale))
	var z = value.a.subtract(value.d).divide(scale_j)

	return {
		"angle": angle,
		"axis": Vector3(x.abs_squared(), y.abs_squared(), z.abs_squared())
	}

func _calculate_circle_parameters(start : Vector3, axis : Vector3):
	start = start.normalized()
	axis = axis.normalized()

	var theta = start.angle_to(axis)
	
	# if fmod(theta, PI) > (PI / 2) - without floating point error
	if snapped(fmod(theta, PI) / (PI / 2.0), 0.1) > 1.0:
		axis = axis * -1.0

	var radius = sin(theta)

	var center = axis * sqrt(1 - radius * radius)
	var perpendicular = axis.cross(start).normalized()

	# return params for the circle

	# For debugging you should use the following variables
	# var mid_point = Vector3(center.x, center.z, -center.y) * sphere_radius
	# var axis_debug = Vector3(axis.x, axis.z, -axis.y)
	
	return {
		"center": center,
		"radius": radius,
		# the parameters for the cosine function
		"a": (start - center).normalized(),
		# the parameters for the sine function
		"b": perpendicular.normalized(),
	}


func interpolate(qubit : Qubit, use_godot_coords : bool, steps : int = 15) -> Dictionary:
	var start = qubit.to_bloch_spehere_pos(false)
	
	# the result of matrix multiplication 
	var last = Qubit.from_vec(self.value.multiply_vec(qubit))

	if not cache.is_empty() and start.is_equal_approx(cache["start"]) and last.is_equal_approx(cache["position"]):
		return cache

	var curve_points : Array[Vector3] = []
	
	# getting the axis and angle of the matrix as a rotation
	var rotation = _get_rotation()
	var axis = rotation['axis']
	var max_angle = rotation['angle']

	# getting the parameters for the parametric circle equation
	var params = _calculate_circle_parameters(start, axis)
	var r = params["radius"]
	var a = params["a"]
	var b = params["b"]
	var center = params["center"]

	# the angle step
	var angle = 0.0
	var delta = max_angle / (steps - 1)

	# the points on the circle
	for i in range(steps):
		# the point on the circle
		var x = center.x + r * a.x * cos(angle) + r * b.x * sin(angle)
		var y = center.y + r * a.y * cos(angle) + r * b.y * sin(angle)
		var z = center.z + r * a.z * cos(angle) + r * b.z * sin(angle)

		var step = Vector3(x, z, -y) if use_godot_coords else Vector3(x, y, z)

		# add the point to the curve
		curve_points.append(step.normalized() * sphere_radius)
		angle += delta

	cache = { "curve_points": curve_points, "position": last, "start": start } 
	return cache
