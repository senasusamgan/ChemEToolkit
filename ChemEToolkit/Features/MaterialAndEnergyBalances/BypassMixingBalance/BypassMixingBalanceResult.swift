struct BypassMixingBalanceResult:
    Equatable,
    Sendable {

    let bypassMassFlow: Double
    let processedBranchMassFlow:
        Double

    let bypassComponentFlow:
        Double
    let processedComponentFlow:
        Double

    let mixedOutletMassFlow:
        Double
    let mixedOutletComponentFlow:
        Double
    let mixedOutletComponentMassFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
