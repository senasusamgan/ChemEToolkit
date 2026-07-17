struct MassFlowMolarFlowConversionInput:
    Equatable,
    Sendable {

    let massFlowRateKilogramsPerHour:
        Double
    let molecularWeightKilogramsPerKilomole:
        Double
}
