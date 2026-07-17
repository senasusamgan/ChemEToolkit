struct IncompressibleEntropyChangeInput:
    Equatable,
    Sendable {

    let mass: Double
    let specificHeatCapacity:
        Double
    let initialTemperatureKelvin:
        Double
    let finalTemperatureKelvin:
        Double
}
