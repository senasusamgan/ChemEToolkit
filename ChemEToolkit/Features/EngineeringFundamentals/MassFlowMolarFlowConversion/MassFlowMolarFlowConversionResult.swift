struct MassFlowMolarFlowConversionResult:
    Equatable,
    Sendable {

    let molarFlowRateKilomolesPerHour:
        Double
    let molarFlowRateMolesPerSecond:
        Double
    let massFlowRateKilogramsPerSecond:
        Double
    let backCalculatedMassFlow:
        Double

    let modelName: String
    let limitationDescription: String
}
