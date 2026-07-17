struct EvaporatorBalanceResult:
    Equatable,
    Sendable {

    let feedSoluteFlow: Double
    let feedSolventFlow: Double

    let concentratedProductFlow:
        Double
    let productSolventFlow:
        Double

    let evaporatedSolventFlow:
        Double
    let concentrationFactor:
        Double
    let solventRemovalFraction:
        Double

    let modelName: String
    let limitationDescription: String
}
