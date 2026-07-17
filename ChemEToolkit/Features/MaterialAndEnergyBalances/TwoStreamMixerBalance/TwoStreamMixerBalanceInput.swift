struct TwoStreamMixerBalanceInput:
    Equatable,
    Sendable {

    let stream1MassFlow: Double
    let stream1ComponentMassFraction:
        Double

    let stream2MassFlow: Double
    let stream2ComponentMassFraction:
        Double
}
