struct ALARPGrossDisproportionScreeningResult:
    Equatable,
    Sendable {

    let projectLifeYears: Int

    let presentValueOfRiskReductionBenefit:
        Double
    let adjustedReasonableCostThreshold:
        Double

    let costToBenefitRatio:
        Double
    let costToAdjustedThresholdRatio:
        Double

    let measureCostIsGrosslyDisproportionate:
        Bool
    let screeningRecommendation:
        String

    let modelName: String
    let limitationDescription: String
}
