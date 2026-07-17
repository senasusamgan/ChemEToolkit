struct CondenserBalanceResult:
    Equatable,
    Sendable {

    let feedCondensableFlow:
        Double
    let feedNoncondensableFlow:
        Double

    let condensateLiquidFlow:
        Double
    let uncondensedVaporFlow:
        Double
    let ventGasFlow: Double

    let ventCondensableMassFraction:
        Double
    let overallCondensationFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
