struct LiquidLeakRateScreeningInput:
    Equatable,
    Sendable {

    let liquidDensity: Double
    let upstreamAbsolutePressure:
        Double
    let downstreamAbsolutePressure:
        Double
    let dischargeCoefficient:
        Double
    let orificeDiameter: Double
    let liquidInventoryVolume:
        Double
}
