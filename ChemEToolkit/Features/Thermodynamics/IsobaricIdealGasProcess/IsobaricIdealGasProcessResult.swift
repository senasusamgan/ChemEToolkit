struct IsobaricIdealGasProcessResult:
    Equatable,
    Sendable {

    let temperatureChange: Double
    let heatToSystem: Double
    let workBySystem: Double
    let internalEnergyChange:
        Double
    let volumeRatio: Double
    let processDirection: String

    let modelName: String
    let limitationDescription: String
}
