struct InherentlySaferDesignChecklistResult:
    Equatable,
    Sendable {

    let principleScore: Double
    let maximumPrincipleScore:
        Double
    let coverageFraction: Double

    let confidenceAdjustedScore:
        Double
    let weakestPrinciple: String

    let maturityBand: String
    let priorityRecommendation:
        String

    let modelName: String
    let limitationDescription: String
}
