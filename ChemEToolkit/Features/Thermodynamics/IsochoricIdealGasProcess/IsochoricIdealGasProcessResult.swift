struct IsochoricIdealGasProcessResult:
    Equatable,
    Sendable {

    let temperatureChange: Double
    let heatToSystem: Double
    let internalEnergyChange:
        Double
    let workBySystem: Double
    let pressureRatio: Double
    let processDirection: String

    let modelName: String
    let limitationDescription: String
}
