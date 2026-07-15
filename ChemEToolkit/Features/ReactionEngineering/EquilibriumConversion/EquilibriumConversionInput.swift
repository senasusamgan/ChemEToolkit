struct EquilibriumConversionInput:
    Equatable,
    Sendable {

    let initialConcentrationA: Double
    let initialConcentrationB: Double
    let equilibriumConstant: Double
}
