struct PBRPressureDropEffectsResult:
    Equatable,
    Sendable {

    let outletPressureRatio: Double
    let outletPressure: Double
    let pressureDrop: Double
    let pressureDropFraction: Double

    let effectiveCatalystExposure:
        Double
    let kineticCoefficientPerCatalystMass:
        Double

    let conversionWithPressureDrop:
        Double
    let conversionWithoutPressureDrop:
        Double
    let conversionPenalty:
        Double

    let outletMolarFlowRateA: Double

    let modelName: String
    let limitationDescription: String
}
