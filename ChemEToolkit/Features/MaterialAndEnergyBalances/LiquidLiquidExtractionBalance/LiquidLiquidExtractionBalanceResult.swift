struct LiquidLiquidExtractionBalanceResult:
    Equatable,
    Sendable {

    let feedCarrierMass: Double
    let initialSoluteMass: Double

    let raffinateSoluteMass:
        Double
    let extractSoluteMass: Double

    let raffinateTotalMass:
        Double
    let extractTotalMass: Double

    let raffinateSoluteRatio:
        Double
    let extractSoluteRatio: Double
    let extractionFraction: Double

    let modelName: String
    let limitationDescription: String
}
