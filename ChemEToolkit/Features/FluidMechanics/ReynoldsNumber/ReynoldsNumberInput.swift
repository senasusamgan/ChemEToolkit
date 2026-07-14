enum ReynoldsNumberViscosity:
    Equatable,
    Sendable {

    case dynamic(
        density: Double,
        dynamicViscosity: Double
    )

    case kinematic(
        kinematicViscosity: Double
    )
}

struct ReynoldsNumberInput:
    Equatable,
    Sendable {

    let velocity: Double
    let diameter: Double
    let viscosity: ReynoldsNumberViscosity
}
