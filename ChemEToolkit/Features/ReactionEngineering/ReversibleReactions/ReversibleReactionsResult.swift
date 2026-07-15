struct ReversibleReactionsResult:
    Equatable,
    Sendable {

    let equilibriumConstant: Double

    let equilibriumConcentrationA: Double
    let equilibriumConcentrationB: Double

    let finalConcentrationA: Double
    let finalConcentrationB: Double

    let signedExtentConcentration:
        Double
    let signedConversionOfInitialA:
        Double

    let finalForwardRate: Double
    let finalReverseRate: Double
    let finalNetRate: Double

    let relaxationFactor: Double
    let approachToEquilibriumFraction:
        Double

    let directionDescription: String
    let modelName: String
    let limitationDescription: String
}
