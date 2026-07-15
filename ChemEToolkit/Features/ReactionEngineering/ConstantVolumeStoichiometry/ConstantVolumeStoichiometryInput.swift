struct ConstantVolumeStoichiometryInput:
    Equatable,
    Sendable {

    let initialConcentrationA: Double
    let initialConcentrationB: Double
    let initialConcentrationProduct:
        Double

    let stoichiometricCoefficientA:
        Double
    let stoichiometricCoefficientB:
        Double
    let stoichiometricCoefficientProduct:
        Double

    let conversionOfA: Double
}
