struct PumpIsentropicEfficiencyResult: Equatable, Sendable {
    let pressureRise: Double
    let idealSpecificWorkInput: Double
    let actualSpecificWorkInput: Double
    let idealPowerInput: Double
    let actualPowerInput: Double
    let inefficiencyPenalty: Double
    let modelName: String
    let limitationDescription: String
}
