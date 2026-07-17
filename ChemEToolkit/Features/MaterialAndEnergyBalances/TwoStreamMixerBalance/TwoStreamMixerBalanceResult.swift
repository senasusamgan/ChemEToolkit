struct TwoStreamMixerBalanceResult:
    Equatable,
    Sendable {

    let outletMassFlow: Double

    let stream1ComponentFlow:
        Double
    let stream2ComponentFlow:
        Double
    let outletComponentFlow:
        Double

    let outletComponentMassFraction:
        Double
    let outletOtherComponentFlow:
        Double

    let modelName: String
    let limitationDescription: String
}
