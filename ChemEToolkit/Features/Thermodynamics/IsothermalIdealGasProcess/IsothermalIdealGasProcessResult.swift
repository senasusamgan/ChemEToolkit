struct IsothermalIdealGasProcessResult:
    Equatable,
    Sendable {

    let pressureRatio: Double
    let volumeRatio: Double
    let workBySystem: Double
    let heatToSystem: Double
    let internalEnergyChange:
        Double
    let processDirection: String

    let modelName: String
    let limitationDescription: String
}
