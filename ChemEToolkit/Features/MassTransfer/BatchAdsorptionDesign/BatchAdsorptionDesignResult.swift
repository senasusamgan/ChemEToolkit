struct BatchAdsorptionDesignResult:
    Equatable,
    Sendable {

    let model:
        BatchAdsorptionEquilibriumModel

    let targetEquilibriumLoading:
        Double
    let soluteRemovedMass: Double
    let requiredAdsorbentMass: Double

    let removalFraction: Double
    let adsorbentToSolutionVolumeRatio:
        Double
    let equilibriumLiquidSoluteMass:
        Double

    let activeEquation: String
    let modelName: String
    let limitationDescription: String
}
