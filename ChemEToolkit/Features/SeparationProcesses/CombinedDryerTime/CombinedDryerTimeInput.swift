struct CombinedDryerTimeInput:
    Equatable,
    Sendable {

    let drySolidMass: Double
    let dryingArea: Double

    let initialMoistureDryBasis:
        Double
    let criticalMoistureDryBasis:
        Double
    let finalMoistureDryBasis:
        Double
    let equilibriumMoistureDryBasis:
        Double

    let constantDryingFlux:
        Double
}
