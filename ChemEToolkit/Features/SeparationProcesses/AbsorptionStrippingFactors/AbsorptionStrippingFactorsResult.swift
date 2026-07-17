struct AbsorptionStrippingFactorsResult:
    Equatable,
    Sendable {

    let absorptionFactor: Double
    let strippingFactor: Double
    let liquidToGasRatio: Double
    let equilibriumWeightedGasFlow:
        Double
    let operationDescription:
        String

    let modelName: String
    let limitationDescription: String
}
