struct GasLeakRateScreeningInput:
    Equatable,
    Sendable {

    let upstreamAbsolutePressure:
        Double
    let downstreamAbsolutePressure:
        Double
    let gasTemperature: Double
    let molecularWeight: Double
    let heatCapacityRatio: Double
    let dischargeCoefficient:
        Double
    let orificeDiameter: Double
}
