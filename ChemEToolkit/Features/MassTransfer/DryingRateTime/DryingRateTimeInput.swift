struct DryingRateTimeInput:
    Equatable,
    Sendable {

    let drySolidMass: Double
    let dryingArea: Double
    let constantDryingFlux: Double

    let initialMoistureContent: Double
    let criticalMoistureContent: Double
    let equilibriumMoistureContent: Double
    let finalMoistureContent: Double
}
