struct AdiabaticIdealGasProcessResult:
    Equatable,
    Sendable {

    let finalTemperatureKelvin:
        Double
    let pressureRatio: Double
    let volumeRatio: Double
    let specificWorkBySystem:
        Double
    let specificInternalEnergyChange:
        Double
    let processDirection: String

    let modelName: String
    let limitationDescription: String
}
