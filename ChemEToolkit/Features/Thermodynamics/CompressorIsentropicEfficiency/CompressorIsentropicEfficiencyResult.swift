struct CompressorIsentropicEfficiencyResult: Equatable, Sendable {
    let isentropicEfficiency: Double
    let idealSpecificWorkInput: Double
    let actualSpecificWorkInput: Double
    let idealPowerInput: Double
    let actualPowerInput: Double
    let excessPowerInput: Double
    let modelName: String
    let limitationDescription: String
}
