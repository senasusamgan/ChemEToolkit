struct GasReliefValveSizingResult:
    Equatable,
    Sendable {

    let specificGasConstant:
        Double
    let pressureRatio: Double
    let criticalPressureRatio:
        Double

    let flowIsChoked: Bool
    let massFlux: Double

    let requiredFlowArea:
        Double
    let equivalentOrificeDiameter:
        Double

    let flowRegimeDescription:
        String

    let modelName: String
    let limitationDescription: String
}
