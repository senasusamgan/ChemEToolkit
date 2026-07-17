struct EmergencyVentilationDilutionInput:
    Equatable,
    Sendable {

    let enclosureVolume: Double
    let ventilationFlowRate: Double
    let initialConcentration:
        Double
    let targetConcentration:
        Double
    let elapsedTime: Double
}
