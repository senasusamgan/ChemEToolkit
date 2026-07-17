struct PolytropicIdealGasProcessInput:
    Equatable,
    Sendable {

    let initialAbsolutePressure:
        Double
    let initialVolume: Double
    let finalAbsolutePressure:
        Double
    let polytropicExponent:
        Double
}
