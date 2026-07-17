struct PolytropicIdealGasProcessResult:
    Equatable,
    Sendable {

    let finalVolume: Double
    let pressureRatio: Double
    let volumeRatio: Double
    let workBySystem: Double
    let initialPV: Double
    let finalPV: Double
    let processDirection: String

    let modelName: String
    let limitationDescription: String
}
