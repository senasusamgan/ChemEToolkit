struct GasMembraneAreaRequirementInput:
    Equatable,
    Sendable {

    let permeateComponentFlow: Double
    let componentPermeance: Double
    let feedSidePartialPressure: Double
    let permeateSidePartialPressure: Double
    let moduleUtilizationFraction: Double
}
