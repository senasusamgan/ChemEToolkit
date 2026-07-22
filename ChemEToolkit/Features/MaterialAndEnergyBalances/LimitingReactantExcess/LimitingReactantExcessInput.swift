struct LimitingReactantExcessInput:
    Equatable,
    Sendable {

    let amountA: Double
    let stoichiometricCoefficientA:
        Double

    let amountB: Double
    let stoichiometricCoefficientB:
        Double
}
