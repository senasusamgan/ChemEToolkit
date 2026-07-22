struct CombustionAirRequirementResult:
    Equatable,
    Sendable {

    let stoichiometricOxygenFlow:
        Double
    let actualOxygenFlow: Double
    let theoreticalAirFlow: Double
    let actualAirFlow: Double
    let nitrogenFlow: Double

    let carbonDioxideFlow: Double
    let waterVaporFlow: Double
    let excessOxygenFlow: Double
    let dryFlueGasFlow: Double

    let modelName: String
    let limitationDescription: String
}
