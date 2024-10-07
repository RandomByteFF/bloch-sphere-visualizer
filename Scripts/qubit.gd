class_name Qubit extends VectorComplex2D

#
# Constructors
#
func _init(a: Complex, b: Complex):
    super(a, b)

static func new_vec(val: VectorComplex2D) -> Qubit:
    return Qubit.new(val.x, val.y)


static var ket_0 = Qubit.new(Complex.new(1), Complex.new(0))
static var ket_1 = Qubit.new(Complex.new(0), Complex.new(1))
static var ket_plus = Qubit.new_vec(VectorComplex2D.new_real(1, 1).multiply_scalar(1.0 / sqrt(2.0)))
static var ket_minus = Qubit.new_vec(VectorComplex2D.new_real(1, -1).multiply_scalar(1.0 / sqrt(2.0)))

#
# Operations
#

func is_valid() -> bool:
    # TODO: this might not be correct because of float inacuraccy therefore needs to be checked later
    return x.abs_squared() + y.abs_squared() == 1

## Returns the 3d representation of `value`
func to_bloch_spehere() -> Vector3:
    # |psi> = r_x * e^(i * phi_x) |0> + r_y * e^(i * phi_y) |1>
    var x_polar = x.get_polar()
    var y_polar = y.get_polar()

    # = r_x |0> + r_y * e^(i * (phi_y - phi_x))
    var beta = y_polar["phi"] - x_polar["phi"]

    # = cos(alpha/2) * |0> + sin(alpha/2) * e^(i*beta) |1>]
    var alpha = acos(x_polar["r"])
    
    # mapping it to bloch sphere
    return Vector3(
        cos(beta) * sin(alpha),
        sin(beta) * sin(alpha),
        cos(alpha)
    )