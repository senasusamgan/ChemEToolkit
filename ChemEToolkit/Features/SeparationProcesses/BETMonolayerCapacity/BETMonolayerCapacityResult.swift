struct BETMonolayerCapacityResult:
    Equatable,
    Sendable {

    let equilibriumLoading:
        Double
    let monolayerEquivalent:
        Double
    let betDenominator:
        Double
    let transformedBETOrdinate:
        Double
    let relativePressure:
        Double

    let modelName: String
    let limitationDescription:
        String
}
